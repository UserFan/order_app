class Type < ApplicationRecord
    has_many :shops, dependent: :restrict_with_error
end
