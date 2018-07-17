class EspCert < ApplicationRecord
  belongs_to :esp

  has_one :shop, through: :esp, foreign_key: :shop_id

  validates :date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
            :date_start_rsa, :date_end_rsa, presence: true

  delegate_missing_to :shop
end
