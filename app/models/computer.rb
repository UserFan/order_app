class Computer < ApplicationRecord

  belongs_to :commouse
  belongs_to :display
  belongs_to :keyboard
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :printer
  belongs_to :shop

  validates :shop_id, :display, presence: true
  #validates :category_id, :date_open, :date_execution, :short_descript, :status_id, presence: true


end
