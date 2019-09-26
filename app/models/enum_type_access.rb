class EnumTypeAccess < ApplicationRecord
  # NOTALLOWED = 1
  # READCURRENT = 2
  # READWRITECURRENT = 3
  # ALLALOWED = 4

  has_many :template_accesses

  #delegate_missing_to :template_access

  validates :name, presence: true

end
