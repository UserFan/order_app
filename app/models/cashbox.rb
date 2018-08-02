class Cashbox < ApplicationRecord

  belongs_to :apc
  belongs_to :bank_unit
  belongs_to :display
  belongs_to :fiscal
  belongs_to :keyboard
  belongs_to :organization_unit
  belongs_to :scaner
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :shop #, counter_cache: true

  has_many :cash_images, dependent: :restrict_with_error

  accepts_nested_attributes_for :cash_images, reject_if: :all_blank, allow_destroy: true

  validates :shop_id, :display_client_id, presence: true

  def display_clien_name
    Display.find(self.display_client_id).name
  end
end
