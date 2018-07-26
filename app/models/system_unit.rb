class SystemUnit < ApplicationRecord
  has_many :cashboxes, dependent: :restrict_with_error
  has_many :computers, dependent: :restrict_with_error

  validates :ram, :motherboard, :hdd, :cpu, presence: true

  def full_conf
    "#{motherboard}/#{cpu}/#{ram}/#{hdd}/#{os}"
  end

end
