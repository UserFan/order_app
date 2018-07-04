class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create
  after_create :create_order_control_user_send_mail
  after_update :change_order_change_user_send_mail


  belongs_to :category
  belongs_to :status
  belongs_to :shop

  has_many :performers, dependent: :destroy #, autosave: true
  has_many :users, through: :performers, foreign_key: :user_id
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
    unless order_number.present?
      self.order_number = "#{(category.name[0..1]).upcase}-#{Date.today.year}-#{Order.last.id+1}"
    end
  end



  private

  def create_order_control_user_send_mail
    #binding.pry
    OrderMailer.with(user: control_user, order: self,
      send_type: 'new_order_control').order_send_mail_to_user.deliver_now
  end

  def change_order_change_user_send_mail
    if changed?
       @@change_order_flag = true
      # binding.pry
       OrderMailer.with(user: control_user, order: self, name_model: self,
         user_type: 'control').send_mail_to_user_order_change.deliver_now
    else
       @@change_order_flag = false
    end
  end
end
