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
    sim_log_change(nil, nil, true) if sim_card_id.present?
  end

  def update_sim_log
    if sim_card_id_changed?
      if (sim_card_id_was.nil? && sim_card_id.present?)
        sim_log_change(nil, nil, true)
      elsif (sim_card_id_was.present? && sim_card_id.nil?)
        sim_log_change(sim_card_id_was, shop.id)
      else
        sim_log_change(sim_card_id_was, shop.id, true)
      end
    end
  end

  def sim_log_change(sim_id=nil, shop_id=nil, add=false)
    unless (sim_id.nil? && shop_id.nil?)
      sim_log = SimLog.find_by(sim_card_id: sim_id,
                               shop_id: shop_id,
                               date_end: nil)
      sim_log.update_attributes(date_end: DateTime.now) if sim_log.present?
    end
    SimLog.create!(sim_card_id: sim_card_id,
                   shop_id: shop.id,
                   date_start: DateTime.now) if add
  end
end
