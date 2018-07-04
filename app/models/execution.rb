class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :performer

  has_many :reworks, dependent: :destroy


  validates :performer_id, :comment, :order_execution, presence: true

  before_destroy :destroy_order_execution

  def execution_result
    Status.find(order_execution).name if order_execution.present?
  end

  def destroy_order_execution
    #binding.pry
    OrderMailer.with(user: performer.order.control_user, order: performer.order,
      name_model: performer.order, user_type: 'execution_delete').
      send_mail_to_user_order_change.deliver_now
  end

end
