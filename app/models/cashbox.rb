class Cashbox < ApplicationRecord
  belongs_to :apc
  belongs_to :bank_unit
  belongs_to :display
  belongs_to :fiscal
  belongs_to :keyboard
  belongs_to :organization_unit
  belongs_to :scaner
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :shop

  validates :shop_id, presence: true
  #validates :category_id, :date_open, :date_execution, :short_descript, :status_id, presence: true

end
