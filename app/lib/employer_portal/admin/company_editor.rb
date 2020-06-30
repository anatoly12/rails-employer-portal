class EmployerPortal::Admin::CompanyEditor < ::EmployerPortal::Admin::Editor

  # ~~ delegates ~~
  delegate :name, :plan, :remote_id, to: :edited

  # ~~ public instance methods ~~
  def update_attributes(params)
    super params.fetch(:company, {}).permit(:name, :plan, :remote_id)
  end

  def plans_for_select
    {
      "Billed by invoice" => [
        ["Passport Lite"],
        ["Passport"],
        ["Passport Complete"],
      ],
      "Billed via Stripe" => [
        ["Self-Service"],
      ],
    }
  end

  def remote_ids_for_select
    ::EmployerPortal::Sync::Partner.where(
      type_of: "CONSUMER",
    ).order(:name).all.map do |partner|
      [partner.name, partner.partner_id]
    end
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Editor ~~
  def self.find_by_id!(id)
    Company.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Company::NotFound)
  end

  def self.new_model
    Company.new
  end
end
