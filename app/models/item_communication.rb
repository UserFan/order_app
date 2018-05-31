class ItemCommunication < ApplicationRecord
  belongs_to :shop_communication
  belongs_to :provider
  belongs_to :communication
  belongs_to :sim_card, optional: true
  belongs_to :modem, optional: true

  # delegate :modem_name, to: :modem

  def modem_name
    Modem.find(modem_id).name if modem_id.present?
  end
end
