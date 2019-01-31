class Execution < ApplicationRecord
  mount_uploaders :images, ImageUploader

  belongs_to :performer

  has_many :reworks, dependent: :delete_all
  has_one :order, through: :performer, foreign_key: :order_id

  validates :performer_id, :comment, :order_execution, presence: true

  ratyrate_rateable 'rating_execution'

  # before_destroy :destroy_order_execution

  def execution_result
    Status.find(order_execution).name if order_execution.present?
  end

  def destroy_order_execution
    # OrderMailer.with(user: performer.order.control_user, order: performer.order,
    #   name_model: performer.order, user_type: 'execution_delete').
    #   send_mail_to_user_order_change.deliver_later(wait: 10.seconds)
  end

end
