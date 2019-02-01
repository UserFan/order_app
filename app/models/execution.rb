class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  after_create :create_execution_user_send_mail
  after_update :change_execution_user_send_mail

  belongs_to :performer

  has_many :reworks, dependent: :delete_all
  has_one :order, through: :performer, foreign_key: :order_id

  validates :performer_id, :comment, :order_execution, presence: true

  ratyrate_rateable 'rating_execution'

  # before_destroy :destroy_order_execution

  def execution_result
    Status.find(order_execution).name if order_execution.present?
  end

  private

  def create_execution_user_send_mail
    OrderMailer.with(user: self.order.owner_user, order: self.order, execution: self,
      send_type: 'order_coordination').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)

    OrderMailer.with(user: self.order.control_user, order: self.order, execution: self,
      send_type: 'order_coordination').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
    if self.order_execution == Status::OFF_CONTROL
      OrderMailer.with(user: self.order.owner_user, order: self.order, execution: self,
        send_type: 'order_off_control').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)


      OrderMailer.with(user: self.performer.user, order: self.order, execution: self,
        send_type: 'order_off_control').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
    end
  end

  def change_execution_user_send_mail
    if self.order_execution == Status::AGREE
      OrderMailer.with(user: self.order.control_user, order: self.order, execution: self,
        send_type: 'order_agree').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)

      OrderMailer.with(user: self.performer.user, order: self.order, execution: self,
        send_type: 'order_agree').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
    end
    if self.order_execution == Status::NOT_COORDINATION
      OrderMailer.with(user: self.order.control_user, order: self.order, execution: self,
        send_type: 'order_not_coordination').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)

      OrderMailer.with(user: self.performer.user, order: self.order, execution: self,
        send_type: 'order_not_coordination').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
    end
  end
end
