class SimLog < ApplicationRecord
  belongs_to :sim_card
  belongs_to :shop
  # validates :text_log, :date_log, :shop_id, presence: true
end
