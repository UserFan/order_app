class Status < ApplicationRecord
  COMPLETED = 1
  EXECUTION = 2
  REVIVAL = 3
  CLOSED = 4
  COORDINATION = 5
  NEW = 6
  NOT_COORDINATION = 7
  AGREE = 8
  OFF_CONTROL = 9
  PART_COMPLETED = 10
  NOT_COMPLETED = 11

  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true

end
