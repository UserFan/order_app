class EnumTypeAccess < ApplicationRecord

  NOTALLOWED = 1
  READONLY = 2
  READWRITEONLY = 3
  ALLALOWED = 4

  has_many :template_accesses, dependent: :delete_all

  validates :name, presence: true

end
