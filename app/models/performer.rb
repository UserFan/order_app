class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  has_one :execution, dependent: :restrict_with_error
  has_many :reworks, through: :executions, foreign_key: :execution_id

  around_destroy :destroy_send_mail
  around_create :performer_send_mail
  around_save :performer_change_user_send

  def execution_off_control?
    if self.execution.present?
      self.execution.completed.present? ? true : (return false)
    else
      return false
    end
  end

  private

  def destroy_send_mail
    binding.pry
  #  OrderMailer.with(user: user, send_type: 'delete_order_control',
  #    order: order).order_send_mail_to_user.deliver_now unless execution_off_control?
    #send_mail_all_control_user
    yield
  end

  def performer_send_mail
    binding.pry
    #OrderMailer.with(user: user, order: order, performer: self,
    #  send_type: 'new_order_performer').order_send_mail_to_user.deliver_later
    #send_mail_all_control_user
    yield
  end

  def performer_change_user_send


    #yield
    #OrderMailer.with(user: user, order: order, performer: self,
    #  send_type: 'change_order').order_send_mail_to_user.deliver_now
    # unless (user == order.performer_executor.user) && (order.performer_executor.execution_off_control?)
    #   OrderMailer.with(user: user, order: order, performer: self,
    #     send_type: 'change_order').order_send_mail_to_user.deliver_now
    # else
    #   OrderMailer.with(user: user, order: order, performer: self,
    #     send_type: 'chage_order').order_send_mail_to_user.deliver_later
    #   OrderMailer.with(user: order.performer_executor.user, order: order, performer: self,
    #     send_type: 'change_order').order_send_mail_to_user.deliver_now
    # end
    yield
    binding.pry
  end

  def send_mail_all_control_user
    unless (user == order.performer_executor.user) && (order.performer_executor.execution_off_control?)
      OrderMailer.with(user: order.performer_executor.user, order: order, performer: self,
        send_type: 'change_order').order_send_mail_to_user.deliver_now
    end
    OrderMailer.with(user: order.control_user, order: order,
              send_type: 'change_order').order_send_mail_to_user.deliver_now
  end

end
