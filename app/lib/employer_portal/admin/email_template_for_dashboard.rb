class EmployerPortal::Admin::EmailTemplateForDashboard < ::EmployerPortal::Admin::Viewer
  # ~~ delegates ~~
  delegate :name, to: :decorated

  def trigger
    decorated.trigger_key.humanize
  end
end
