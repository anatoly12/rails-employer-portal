require "csv"

module EmployerPortal
  class EmployeeBulkImport

    # ~~ public instance methods ~~
    def initialize(params={})
      @file = params[:file]
    end

    def has_file?
      @file.respond_to?(:path) && File.size(@file.path)>0
    end

    def csv
      parsed_csv
    end

  private

    def original_ext
      File.extname(@file.original_filename).downcase
    end

    def column_separator
      original_ext==".csv" ? "," : "\t"
    end

    def encoding
      (original_ext==".csv" || original_ext==".tsv") ? "UTF-8" : "bom|UTF-16LE"
    end

    def parsed_csv
      options = {col_sep: column_separator, skip_blanks: true}
      retries = 0
      begin
        content = File.read @file.tempfile.path, encoding: encoding, mode: "rb"
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
