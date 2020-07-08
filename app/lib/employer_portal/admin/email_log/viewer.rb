class EmployerPortal::Admin::EmailLog::Viewer < ::EmployerPortal::Admin::Base::Viewer

  # ~~ delegates ~~
  delegate :trigger_key, :recipient, :id, :from, :subject, :html, :text, to: :decorated

  # ~~ public class methods ~~
  def self.from_params(context, params)
    decorated = EmailLog.where(
      id: params[:id],
    ).limit(1).first || raise(::EmployerPortal::Error::EmailLog::NotFound)
    new context, decorated
  end

  # ~~ public instance methods ~~
  def created_at
    decorated.created_at.strftime("%F %R UTC")
  end

  def company_name
    decorated.company.name
  end
end
