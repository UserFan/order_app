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
  SIGNED = 12
  NOT_SIGNED = 13
  COORDINATION_MANAGER = 14
  NOT_COORDINATION_MANAGER = 15
  AGREE_MANAGER = 16
  SIGNING = 17
  MADE = 18
  GENERATED = 19

  has_many :orders, dependent: :restrict_with_error
  has_many :tasks, dependent: :restrict_with_error
  has_many :report_cost_services, dependent: :restrict_with_error

  validates :name, presence: true


end
