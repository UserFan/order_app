class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create
  after_create :control_user_send_mail
  around_update :order_change_user_send_mail

  belongs_to :category
  belongs_to :status
  belongs_to :shop

  has_many :performers, dependent: :destroy, autosave: true
  has_many :users, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :order_id
  has_many :reworks, through: :executions

  validates :user_id, :date_open, :date_execution, :short_descript, presence: true

  def control_name
    User.find(self.user_id).full_name
  end

  def number_create
    unless order_number.present?
      self.order_number = "#{(category.name[0..1]).upcase}-#{Date.today.year}-#{Order.last.id+1}"
    end
  end

  private

  def control_user_send_mail
    OrderMailer.with(user: User.find(user_id), order: self, send_type: 'new_order').order_control_user.deliver_now
    #OrderMailer.with(user: User.find(user_id), order: self).new_order.deliver_now
  end

  def order_change_user_send_mail
    OrderMailer.with(user: User.find(user_id), order: self).order_change.deliver_now
    # if self.changed?
    #   if user_id_changed?
    #     user_control = User.find(user_id_change[1])
    #     OrderMailer.with(user: User.find(user_id_change[0]), order: self).delete_order_control.deliver_now
    #     OrderMailer.with(user: user_control, order: self).new_order_control.deliver_now
    #   else
    #     user_control = User.find(user_id)
    #   end
    #   OrderMailer.with(user: user_control, order: self).order_change.deliver_now unless order_performer_change? || order_status_change?
    #   OrderMailer.with(user: user_control, order: self).order_change_status.deliver_now if order_status_change?
    #
    #   # unless (status_id_changed?) && (status_id_change[0] == Status::NEW) && (status_id_change[1] == Status::EXECUTION)
    #   #   OrderMailer.with(user: user_control, order: self).order_change_status.deliver_now if order_status_change?
    #   # end
    #   performers.each do |performer|
    #     OrderMailer.with(user: performer.user, order: self).order_change.deliver_now unless order_performer_change? || order_status_change?
    #     OrderMailer.with(user: performer.user, order: self).order_change_status.deliver_now if order_status_change?
    #   end
    # end
    yield
  end

  # def order_performer_change?
  #   change = 0
  #   performers.each { |performer| change += 1 if performer.changed? }
  #   change > 0 ? true : false
  # end
  #
  # def order_status_change?
  #   if (status_id == Status::AGREE) || (status_id == Status::COORDINATION) || (status_id == Status::NOT_COORDINATION)
  #     return true
  #   else
  #     return false
  #   end
  # end

  # def order_execution_change?
  #   unless (status_id_changed?) && (status_id_change[0] == Status::NEW) && (status_id_change[1] == Status::EXECUTION)
  #     OrderMailer.with(user: user_control, order: self).order_change_status.deliver_now if order_status_change?
  #   end
  #
  # end

end
