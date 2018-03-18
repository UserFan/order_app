class ItemCommunication < ApplicationRecord
  belongs_to :shop_communication
  belongs_to :provider
  belongs_to :communication

  # delegate :modem_name, to: :modem

  def modem_name
    Modem.find(modem_id).name
  end
end
