class CashImage < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :cashbox

  validates :cashbox_id, :date_add, presence: true
  
end
