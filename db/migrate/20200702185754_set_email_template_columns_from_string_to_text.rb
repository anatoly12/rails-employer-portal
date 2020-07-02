# frozen_string_literal: true

Sequel.migration do
  change do
    [:email_templates, :email_logs].each do |table|
      alter_table table do
        set_column_type :subject, String, text: true
        set_column_type :html, String, text: true
        set_column_type :text, String, text: true
      end
    end
  end
end
