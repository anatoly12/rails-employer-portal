class EmployerPortal::SymptomLog::Viewer

  # ~~ delegates ~~
  delegate :to_param, :log_date, :temperature, to: :symptom_log

  # ~~ public instance methods ~~
  def initialize(context, symptom_log)
    @context = context
    @symptom_log = symptom_log
  end

  def flagged?
    symptom_log.flagged == 1
  end

  def symptoms?
    symptom_log.flagged == 1
  end

  private

  attr_reader :context, :symptom_log
end
