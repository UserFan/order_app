class Performer < ApplicationRecord
  belongs_to :order, inverse_of: :performers
  belongs_to :employee, inverse_of: :performers
  #belongs_to :user, counter_cache: :orders_count

  has_one :execution, dependent: :restrict_with_error
  has_many :reworks, through: :executions, foreign_key: :execution_id

  # before_destroy :destroy_performer_send_to_mail_user
  # after_create :create_performer_send_to_mail_user
  # after_update :change_performer_send_to_mail_user

  # default_scope { order(coexecutor: :asc) }

  validates :employee_id, :deadline, presence: true

  def execution_off_control?
    # if self.execution.present?
    #   self.execution.completed.present? ||
    #   self.date_close_performance.present? ? true : (return false)
    # else
    #   return false
    # end
  end

  private

  def destroy_performer_send_to_mail_user
  #  binding.pry
    # OrderMailer.with(user: user, send_type: 'delete_order_control',
    #   order: order).order_send_mail_to_user.deliver_later(wait: 10.seconds) unless execution_off_control?
    #
    # send_mail_all_control_user(true)
  end

  def create_performer_send_to_mail_user
    #binding.pry
    # OrderMailer.with(user: user, order: order, performer: self,
    #    send_type: 'new_order_performer').order_send_mail_to_user.deliver_now
    #
    # send_mail_all_control_user(true)
    #binding.pry
  end

  def change_performer_send_to_mail_user
    #binding.pry
    # if ((@@change_order_flag) && (changed?)) || (@@change_order_flag)
    #   #binding.pry
    #   OrderMailer.with(user: user, order: order, name_model: self,
    #     user_type: 'performer').send_mail_to_user_order_change.deliver_now unless execution_off_control?
    # elsif changed?
    #   #binding.pry
    #   OrderMailer.with(user: user, order: order, name_model: self,
    #     user_type: 'performer').send_mail_to_user_order_change.deliver_now unless execution_off_control?
    #   send_mail_all_control_user(true)
    # end
  end

  def send_mail_all_control_user(changed_perform=false)
  #   changed_perform ? $send_change += 1 : $send_change = 0
  # #  binding.pry
  #   if ((order.performer_executor.present?) && ($send_change < 2))
  #     #binding.pry
  #     unless ((user == order.performer_executor.user) ||
  #            (order.performer_executor.execution_off_control?))
  #
  #       OrderMailer.with(user: order.performer_executor.user, order: order, performer: self,
  #         send_type: 'change_order').order_send_mail_to_user.deliver_later(wait: 10.seconds)
  #     end
  #   end
  #   OrderMailer.with(user: order.control_user, order: order, performer: self,
  #     send_type: 'change_order').order_send_mail_to_user.deliver_later(wait: 10.seconds)  unless (@@change_order_flag || $send_change > 1)
  end

end
