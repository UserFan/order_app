class TaskPerformer < ApplicationRecord
  belongs_to :task, inverse_of: :task_performers
  belongs_to :employee, inverse_of: :task_performers
  #belongs_to :user, counter_cache: :orders_count

  has_one :task_execution, dependent: :restrict_with_error
  #has_many :reworks, through: :executions, foreign_key: :execution_id
  has_one :user, through: :employee, foreign_key: :user_id

  #after_create :create_performer_send_to_mail_user

  validates :employee_id, :deadline, presence: true

  #ratyrate_rateable 'rating_performer'

  private

  # def create_performer_send_to_mail_user
  #   OrderMailer.with(user: self.user, order: self.order,
  #     send_type: 'new_order_performer').order_send_mail_to_user.deliver_later(wait: 10.seconds)
  # end
end
