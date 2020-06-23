require "csv"

module EmployerPortal
  class EmployeeBulkImport

    # ~~ public instance methods ~~
    def initialize(context, file)
      @context = context
      @file = file
      @errors = []
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
      persist!
      enqueue_background_jobs
    rescue CSV::MalformedCSVError => e
      raise_error "Error: invalid file format."
    end

    private

    attr_reader :context, :file, :errors

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

    def persist!
      Employee.import(
        employees.first.values.keys,
        employees.map { |employee| employee.values.values }
      )
    end

    def enqueue_background_jobs
      employees.each do |employee|
        CreateAccountForEmployeeJob.perform_later employee.uuid
      end
    end

    def raise_error(message)
      raise ::EmployerPortal::Error::EmployeeBulkImport::Invalid, message
    end
  end
end
