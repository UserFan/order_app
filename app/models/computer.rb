class Computer < ApplicationRecord

  belongs_to :commouse
  belongs_to :display
  belongs_to :keyboard
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :printer
  belongs_to :shop

  validates :shop_id, presence: true

end
