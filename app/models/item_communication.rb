class ItemCommunication < ApplicationRecord
  belongs_to :shop_communication, counter_cache: true
  belongs_to :provider
  belongs_to :communication
  belongs_to :sim_card, optional: true
  belongs_to :modem, optional: true

  has_one :shop, through: :shop_communication

  def modem_name
    Modem.find(modem_id).name if modem_id.present?
  end
end
