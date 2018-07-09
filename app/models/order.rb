class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create
  after_create :create_order_control_user_send_mail
  after_update :change_order_change_user_send_mail
  after_destroy :destroy_order_user_send_mail


  belongs_to :category
  belongs_to :status
  belongs_to :shop, counter_cache: true
  
  has_many :performers, dependent: :destroy #, autosave: true
  has_many :users, through: :performers, foreign_key: :user_id, counter_cache: true
  has_many :executions, through: :performers, foreign_key: :order_id
  has_many :reworks, through: :executions

  validates :user_id, :date_open, :date_execution, :short_descript, presence: true


  def control_user
    User.find(user_id)
  end

  def control_user_changed?
     user_id_changed? ? true : (return false)
  end

  def control_user_old
     user_id_changed? ? User.find(user_id_was) : User.find(user_id)
  end

  def performer_executor
    self.performers.find_by(coexecutor: false)
  end

  def number_create
    Order.last.present? ? order_last_number = self.last.id + 1 : order_last_number = 0
    self.order_number = "#{(category.name[0..1]).upcase}-#{Date.today.year}-#{order_last_number}" unless order_number.present?
  end

  private

  def destroy_order_user_send_mail
    OrderMailer.with(user: control_user, order: self,
      send_type: 'delete_order').order_send_mail_to_user.deliver_now
  end

  def create_order_control_user_send_mail
    OrderMailer.with(user: control_user, order: self,
      send_type: 'new_order_control').order_send_mail_to_user.deliver_later(wait: 10.seconds)
  end

  def change_order_change_user_send_mail
    #binding.pry
    if changed?
       @@change_order_flag = true
       OrderMailer.with(user: control_user, order: self, name_model: self,
         user_type: 'control').send_mail_to_user_order_change.deliver_now
    else
       @@change_order_flag = false
    end
  end
end
