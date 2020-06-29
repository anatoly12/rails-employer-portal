module EmployerPortal
  class EmployeeStats

    # ~~ public instance methods ~~
    def initialize(context, dataset)
      @context = context
      @dataset = dataset
    end

    def no_symptoms_percent
      return 0 unless context.sync_connected? && total>0

      count_by_daily_checkup_status.fetch("Cleared", 0) * 100 / total
    end

    def symptoms_percent
      return 0 unless context.sync_connected? && total>0

      count_by_daily_checkup_status.fetch("Not Cleared", 0) * 100 / total
    end

    def did_not_submit_percent
      100-no_symptoms_percent-symptoms_percent
    end

    def cleared_percent
      return 0 unless context.sync_connected? && total>0

      count_by_testing_status.fetch("Cleared", 0) * 100 / total
    end

    def inconclusive_percent
      return 0 unless context.sync_connected? && total>0

      count_by_testing_status.fetch("Inconclusive", 0) * 100 / total
    end

    def in_progress_percent
      100-cleared_percent-inconclusive_percent
    end

    private

    attr_reader :context, :dataset

    # ~~ private instance methods ~~
    def total
      @total ||= count_by_daily_checkup_status.values.sum
    end

    def count_by_daily_checkup_status
      @count_by_daily_checkup_status ||= dataset.group_and_count(
        :daily_checkup_status
      ).to_a.each_with_object({}) do |raw, hash|
        hash[raw[:daily_checkup_status]] = raw[:count]
      end
    end

    def count_by_testing_status
      @count_by_testing_status ||= dataset.group_and_count(
        :testing_status
      ).to_a.each_with_object({}) do |raw, hash|
        hash[raw[:testing_status]] = raw[:count]
      end
    end
  end
end
