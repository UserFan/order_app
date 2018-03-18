class Role < ApplicationRecord
  GUIDE_ID = 2
  
  has_many :users

  validates :name, presence: true
end
