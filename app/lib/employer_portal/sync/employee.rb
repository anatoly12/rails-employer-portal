class EmployerPortal::Sync::Employee

  # ~~ public instance methods ~~
  def initialize(schema, secret_key_base, employee, now = Time.now)
    @schema = schema
    @secret_key_base = secret_key_base
    @employee = employee
    @now = now
  end

  def create_account!
    password = "your existing password"
    db.transaction do
      account = create_or_update_account
      password = raw_password if account.encrypted_password == encrypted_password
      create_user_if_needed(account)
      create_demographic_if_needed(account)
      create_requisition(account)
      create_access_grant(account)
      employee.update remote_id: account.id, remote_sync_at: now
    end
    EmailTriggerJob.perform_later(
      EmailTemplate::TRIGGER_EMPLOYEE_NEW,
      employee.uuid,
      "reset_password_token" => reset_password_token_raw,
      "password" => password,
    )
  rescue Sequel::Error => e
    raise ::EmployerPortal::Error::Sync::CantCreateAccount, e.message
  end

  private

  attr_reader :schema, :secret_key_base, :employee, :now

  # ~~ private instance methods ~~
  def db
    Sequel::Model.db
  end

  def generate_random_string
    SecureRandom.urlsafe_base64(15).tr "lIO0", "sxyz"
  end

  def raw_password
    @raw_password ||= generate_random_string
  end

  def encrypted_password
    @encrypted_password ||= ::BCrypt::Password.create(raw_password).to_s
  end

  def devise_reset_password_token
    @devise_reset_password_token ||= begin
        key = ActiveSupport::KeyGenerator.new(
          secret_key_base
        ).generate_key "Devise reset_password_token"
        loop do
          raw = generate_random_string
          enc = OpenSSL::HMAC.hexdigest "SHA256", key, raw
          break [raw, enc] if ::EmployerPortal::Sync::Account.where(reset_password_token: enc).limit(1).empty?
        end
      end
  end

  def reset_password_token_raw
    devise_reset_password_token[0]
  end

  def reset_password_token_digest
    devise_reset_password_token[1]
  end

  def create_or_update_account
    account_id = ::EmployerPortal::Sync::Account.dataset.on_duplicate_key_update(
      :is_active,
      :reset_password_token,
      :reset_password_sent_at,
      :updated_at
    ).insert(
      email: employee.email,
      encrypted_password: encrypted_password,
      is_active: true,
      reset_password_token: reset_password_token_digest,
      reset_password_sent_at: now,
      created_at: now,
      updated_at: now,
    )
    ::EmployerPortal::Sync::Account[account_id]
  end

  def create_user_if_needed(account)
    return if account.user_id

    account.update user_id: ::EmployerPortal::Sync::User.insert(
      email: employee.email,
      first_name: employee.first_name,
      last_name: employee.last_name,
      created_at: now,
      updated_at: now,
    )
  end

  def create_demographic_if_needed(account)
    return if account.demographic

    ::EmployerPortal::Sync::Demographic.create(
      account: account,
      full_legal_name: "#{employee.first_name} #{employee.last_name}",
      state_of_residence: employee.state,
      phone_number: employee.phone,
      created_at: now,
      updated_at: now,
    )
  end

  def partner_id
    employee.company.remote_id
  end

  def create_requisition(account)
    return unless partner_id

    t_kit_id = ::EmployerPortal::Sync::Partner[partner_id]&.passport_product&.t_kit_id
    return unless t_kit_id

    requisition_needed = ::EmployerPortal::Sync::Kit.eager_graph(:requisition).where(
      schema[:ec_kits][:t_kit_id] => t_kit_id,
      schema[:ec_kits][:partner_id] => partner_id,
      Sequel.qualify(:requisition, :user_id) => account.user_id,
    ).limit(1).empty?
    return unless requisition_needed

    kit_id = call_stored_procedure(
      :ec_create_kit,
      t_kit_id,
      partner_id,
      "''",
      "@i_new_kit_id"
    )[:i_new_kit_id]
    call_stored_procedure(
      :ec_create_requisition,
      account.user_id,
      "'#{::EmployerPortal::Sync::Kit.where(kit_id: kit_id).get(:barcode)}'",
      "@n_new_req_id"
    )
  end

  def create_access_grant(account)
    return unless partner_id
    return if account.access_grants.any? { |g| g.access_code&.partner_id == partner_id }

    access_code_id = ::EmployerPortal::Sync::AccessCode.where(partner_id: partner_id).get(:id)
    return unless access_code_id

    ::EmployerPortal::Sync::AccessGrant.create(
      account: account,
      partner_access_code_id: access_code_id,
      created_at: now,
      updated_at: now,
    )
  end

  def call_stored_procedure(procedure, *args)
    res = nil
    db.synchronize do |conn|
      res = conn.query("CALL `#{schema.value}`.#{procedure}(#{args.join(",")})")
      while conn.next_result
        conn.store_result
      end
    end
    res.first
  end
end
