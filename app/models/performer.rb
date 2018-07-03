class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  has_one :execution, dependent: :restrict_with_error
  has_many :reworks, through: :executions, foreign_key: :execution_id

  before_destroy :destroy_performer_send_to_mail_user
  after_create :create_performer_send_to_mail_user
  after_update :change_performer_send_to_mail_user

  def execution_off_control?
    if self.execution.present?
      self.execution.completed.present? ? true : (return false)
    else
      return false
    end
  end

  private

  def destroy_performer_send_to_mail_user
   #binding.pry
   OrderMailer.with(user: user, send_type: 'delete_order_control',
     order: order).order_send_mail_to_user.deliver_now unless execution_off_control?

  send_mail_all_control_user
  end

  def create_performer_send_to_mail_user
    #binding.pry
    OrderMailer.with(user: user, order: order, performer: self,
       send_type: 'new_order_performer').order_send_mail_to_user.deliver_now

    send_mail_all_control_user
    #yield
    binding.pry
  end

  def change_performer_send_to_mail_user
    # if ((@@change_order_flag) && !(execution_off_control?))
    #   OrderMailer.with(user: user, order: order, performer: self,
    #     send_type: 'change_order').order_send_mail_to_user.deliver_now
    # end
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
    #binding.pry
    #yield
    binding.pry
  end

  def send_mail_all_control_user
    binding.pry
    if (order.performer_executor.present?)
      unless ((user == order.performer_executor.user) &&
             (order.performer_executor.execution_off_control?))

        OrderMailer.with(user: order.performer_executor.user, order: order, performer: self,
          send_type: 'change_order').order_send_mail_to_user.deliver_now
      end
    end
    OrderMailer.with(user: order.control_user, order: order, performer: self,
              send_type: 'change_order').order_send_mail_to_user.deliver_now  unless @@change_order_flag
  end

end
