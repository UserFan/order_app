class ItemCommunication < ApplicationRecord
  belongs_to :shop_communication, counter_cache: true
  belongs_to :provider
  belongs_to :communication
  belongs_to :sim_card, optional: true
  belongs_to :modem, optional: true

  after_create :add_sim_log
  after_update :update_sim_log

  has_one :shop, through: :shop_communication

  default_scope { order(master: :desc) }

  def modem_name
    Modem.find(modem_id).name if modem_id.present?
  end

  private

  def add_sim_log
    SimLog.create!(sim_card_id: sim_card_id,
                   shop_id: shop.id,
                   date_start: DateTime.now) if sim_card_id.present?
  end

  def update_sim_log
    if sim_card_id_changed?
      unless sim_card_id_was.nil?
        sim_log = SimLog.find_by(sim_card_id: sim_card_id_was,
                                 shop_id: shop.id,
                                 date_end: nil)
        sim_log.update_attributes(date_end: DateTime.now) if sim_log.present?
      end
      SimLog.create!(sim_card_id: sim_card_id,
                     shop_id: shop.id,
                     date_start: DateTime.now) unless sim_card_id.nil?
    end
  end
end
