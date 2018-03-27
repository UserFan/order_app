class Status < ApplicationRecord
  NOT_COORDINATION = 7
  COMPLITED = 1
  EXECUTION = 2
  CHANGE_PERFORMER = 3
  CLOSED = 4
  COORDINATION = 5
  NEW = 6
  NOT_COORDINATION = 7

  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true

end
