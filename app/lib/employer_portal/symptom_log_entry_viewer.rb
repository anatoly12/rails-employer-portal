module EmployerPortal
  class SymptomLogEntryViewer
    # ~~ constants ~~
    TYPE_DATE = "DATE"
    TYPE_TEXT = "TEXT"
    TYPE_LIST = "LIST_OPT"

    # ~~ delegates ~~
    delegate :question, :response, to: :entry

    # ~~ public instance methods ~~
    def initialize(context, entry)
      @context = context
      @entry = entry
    end

    def type_date?
      entry.question_type == TYPE_DATE
    end

    def type_text?
      entry.question_type == TYPE_TEXT
    end

    def type_list?
      entry.question_type == TYPE_LIST
    end

    def options
      entry.options.split("||")
    end

    def visible?
      response.present? || required?
    end

    private

    attr_reader :context, :entry

    def required?
      entry.required
    end
  end
end
