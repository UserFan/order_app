class Status < ApplicationRecord
  CLOSED = 4
  NEW = 6
  COORDINATION = 5
  CHANGE_PERFORMER = 3
  

  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true

end
