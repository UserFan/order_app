class EspCert < ApplicationRecord
  belongs_to :esp

  validates :date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
            :date_start_rsa, :date_end_rsa, presence: true
end
