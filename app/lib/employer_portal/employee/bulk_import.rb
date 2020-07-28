require "csv"

class EmployerPortal::Employee::BulkImport

  # ~~ accessors ~~
  attr_reader :tags

  # ~~ delegates ~~
  delegate :whitelist, to: :employee_tag, prefix: :tags

  # ~~ public class methods ~~
  def self.from_params(context, params)
    file = params[:file]
    tags = params[:tags].to_s.split(",").map(&:strip).reject(&:empty?)
    new context, file, tags
  end

  # ~~ public instance methods ~~
  def initialize(context, file, tags)
    @context = context
    @file = file
    @tags = tags
    @now = Time.now
    @errors = []
    @tags_after = []
    @employee_ids = []
  end

  def has_file?
    file.respond_to?(:path) && File.size(file.path) > 0
  end

  def count
    employees.size
  end

  def save!
    raise_error "Error: can't find any employee in given file." if employees.empty?
    validate
    raise_error errors.first if errors.any?
    persist
    enqueue_background_jobs
  rescue CSV::MalformedCSVError => e
    raise_error "Error: invalid file format."
  end

  private

  attr_reader :context, :file, :now, :errors, :tags_after, :employee_ids

  def original_ext
    File.extname(file.original_filename).downcase
  end

  def column_separator
    original_ext == ".csv" ? "," : "\t"
  end

  def encoding
    (original_ext == ".csv" || original_ext == ".tsv") ? "UTF-8" : "bom|UTF-16LE"
  end

  def parsed_csv
    options = { col_sep: column_separator, skip_blanks: true }
    retries = 0
    begin
      content = File.read file.tempfile.path, encoding: encoding, mode: "rb"
      CSV.parse content, **options
    rescue CSV::MalformedCSVError
      if retries.zero?
        options[:force_quotes] = true
        retries += 1
        retry
      else
        raise
      end
    end
  end

  def employees
    @employees ||= parsed_csv.drop(1).map do |row|
      Employee.new(
        company_id: context.company_id,
        employer_id: context.account_id,
        first_name: row[0],
        last_name: row[1],
        email: row[2],
        phone: row[3],
        zipcode: row[4],
      )
    end
  end

  def validate
    errors.clear
    employees.each_with_index do |employee, index|
      unless employee.valid?
        errors << "Error(s) on row #{index + 2}: #{employee.errors.full_messages.to_sentence}."
      end
    end
  end

  def persist
    Sequel::Model.db.transaction do
      persist_tags
      persist_employees
      persist_taggings
      persist_audit
    end
  end

  def employee_tag
    @employee_tag ||= ::EmployerPortal::EmployeeTag.new context
  end

  def persist_tags
    @tags_after = employee_tag.find_or_create_tags [], tags
  end

  def persist_employees
    columns = employees.first.columns
    rows = employees.map { |employee| employee.values.slice(*columns) }
    @employee_ids = Employee.import(
      rows.first.keys,
      rows.map(&:values),
      return: :primary_key,
    )
  end

  def persist_taggings
    taggings = employee_ids.flat_map do |employee_id|
      tags_after.map do |employee_tag|
        [employee_id, employee_tag.id, now]
      end
    end
    return if taggings.empty?

    EmployeeTagging.import(
      [:employee_id, :employee_tag_id, :created_at],
      taggings
    )
  end

  def persist_audit
    Audit.create(
      item_type: Employee,
      item_id: nil,
      event: "import",
      changes: {
        ids: employee_ids,
        tags: tags_after.map(&:name).sort.join(","),
      },
      created_at: now,
      created_by_type: Sequel::Plugins::WithAudits.created_by_type,
      created_by_id: Sequel::Plugins::WithAudits.created_by_id,
    ) if employee_ids.any?
  end

  def enqueue_background_jobs
    employees.each do |employee|
      CreateAccountForEmployeeJob.perform_later employee.uuid
    end
  end

  def raise_error(message)
    raise ::EmployerPortal::Error::Employee::BulkImport::Invalid, message
  end
end
