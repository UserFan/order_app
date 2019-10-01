class EspCert < ApplicationRecord
  belongs_to :esp

  has_one :shop, through: :esp, foreign_key: :shop_id

  validates :date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
            :date_start_rsa, :date_end_rsa, presence: true

  delegate_missing_to :shop

  scope :count_cert_esp,
    -> (date_start) { by_month(date_start, field: :date_end_esp).size }

  scope :count_cert_rsa,
    -> (date_start) { by_month(date_start, field: :date_end_rsa).size }


  # scope :roles, -> (user) { user.template_roles.where(
  #                           resource_names: {table_name: "esp_cert"},
  #                           action_apps: {action_app_name: "export"}).
  #                           joins(action_name: [:action_app, :resource_name]).
  #                           pluck(:type_access) }
end
