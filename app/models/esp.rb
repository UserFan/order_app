class Esp < ApplicationRecord
  belongs_to :carrier_type
  belongs_to :shop

  has_many :esp_certs, inverse_of: :esp, dependent: :restrict_with_error

  validates :carrier_type_id, presence: true
end
