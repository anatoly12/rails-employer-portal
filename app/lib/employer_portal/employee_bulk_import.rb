require "csv"

module EmployerPortal
  class EmployeeBulkImport

    # ~~ public instance methods ~~
    def initialize(employer, file)
      @employer = employer
      @file = file
    end

    def has_file?
      file.respond_to?(:path) && File.size(file.path) > 0
    end

    def csv
      Sequel::Model.db.transaction do
        parsed_csv.drop(1).each do |row|
          Employee.create(
            company_id: employer.company_id,
            employer_id: employer.id,
            first_name: row[0],
            last_name: row[1],
            email: row[2],
            phone: row[3],
            zipcode: row[4],
          )
        end
      end
    end

    private

    attr_reader :employer, :file

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
        CSV.parse content, options
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
  end
end
