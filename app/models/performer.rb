class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  has_one :execution, dependent: :restrict_with_error
  has_many :reworks, through: :executions, foreign_key: :execution_id

  around_destroy :destroy_send_mail
  after_create :performer_send_mail
  around_update :order_change_user_send_mail

  private

  def destroy_send_mail
    OrderMailer.with(user: user, order: order).delete_performer_order.deliver_now
    yield
  end

  def performer_send_mail
    OrderMailer.with(user: user, order: order, performer: self).new_order.deliver_now
  end

  def order_change_user_send_mail
    if self.changed?
      OrderMailer.with(user: User.find(order.user_id), order: self.order).order_change.deliver_now
      if user_id_changed?
        OrderMailer.with(user: User.find(user_id_change[0]), order: self.order).delete_performer_order.deliver_now
        OrderMailer.with(user: User.find(user_id_change[1]), order: order, performer: self).new_order.deliver_now
      else
        OrderMailer.with(user: user, order: self.order).order_change.deliver_now
        OrderMailer.with(user: order.performers.find_by(coexecutor: false).user,
                         order: self.order).order_change.deliver_now if coexecutor?
      end
    end
    yield
  end

end
