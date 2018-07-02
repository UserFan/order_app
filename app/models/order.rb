class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create
  #after_create :control_user_send_mail
  around_save :order_change_user_send_mail


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

  def performers_change?
    #self.performers.exists? {|e| e.changed? } ? true : (return false)
    self.performers.any? {|e| e.changed? } ? true : (return false)
  end

  private

  def control_user_send_mail
    OrderMailer.with(user: control_user, order: self,
      send_type: 'new_order_control').order_send_mail_to_user.deliver_now
    #OrderMailer.with(user: User.find(user_id), order: self).new_order.deliver_now
  end

  def order_change_user_send_mail

    #OrderMailer.with(user: control_user, order: self).send_mail_order_change.deliver_now


    changed? ? @@change_order_flag = true : @@change_order_flag = false
    yield

    binding.pry
  end




end
