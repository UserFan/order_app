class CashImage < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :cashbox

  has_one :shop, through: :cashbox, foreign_key: :shop_id

  validates :cashbox_id, :date_add, presence: true

end
