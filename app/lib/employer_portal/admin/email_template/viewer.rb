class EmployerPortal::Admin::EmailTemplate::Viewer < ::EmployerPortal::Admin::Base::Viewer
  # ~~ delegates ~~
  delegate :name, to: :decorated

  def trigger
    decorated.trigger_key.humanize
  end

  def plan
    decorated.plan_id ? decorated.plan.name : "All plans"
  end
end
