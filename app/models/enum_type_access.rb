class EnumTypeAccess < ApplicationRecord
  NOTALLOWED = 1
  READCURRENT = 2
  READWRITECURRENT = 3
  ALLALOWED = 4
  has_many :template_accesses, dependent: :restrict_with_error

  delegate_missing_to :template_access

  validates :name, presence: true

end
