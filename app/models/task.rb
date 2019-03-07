class Task < ApplicationRecord
  mount_uploaders :images_document, PdfUploader

  before_create :number_create
  # after_create :create_order_control_user_send_mail
  # after_update :change_order_change_user_send_mail

  belongs_to :type_document
  belongs_to :status
  belongs_to :shop, foreign_key: :structural_id
  belongs_to :employee

  has_many :task_performers, inverse_of: :task, dependent: :delete_all #, autosave: true
  # has_many :users, through: :employee, foreign_key: :user_id, counter_cache: true
  #
  has_many :task_executions, through: :task_performers, foreign_key: :task_id
  # has_many :reworks, through: :executions

  validates :employee_id, :date_open, :date_execution, :description, :structural_id, presence: true

  scope :tasks_user, -> (user) { where("employees.user_id = ?", user).
                or(Task.where("employees_task_performers.user_id = ?", user)).
                left_outer_joins(:employee, :task_executions, task_performers: :employee).
                includes(:shop, :status, :type_document).distinct }

  def owner_user
    User.find(self.employee.user_id)
  end

  def number_create
    Task.last.present? ? task_last_number = Task.last.id + 1 : task_last_number = 1
    self.task_number = "#{(type_document.name[0..1]).upcase}-#{Date.today.year}-#{task_last_number}" unless task_number.present?
  end

  private

  # def create_order_control_user_send_mail
  #   OrderMailer.with(user: control_user, order: self,
  #     send_type: 'new_order_control').order_send_mail_to_user.deliver_later(wait: 10.seconds)
  # end
  #
  # def change_order_change_user_send_mail
  #
  #   OrderMailer.with(user: self.owner_user, order: self,
  #     send_type: 'order_change_owner').order_send_mail_to_owner_user.deliver_later(wait: 30.seconds) if self.status_id == Status::EXECUTION
  #
  #   if self.date_closed.present?
  #     OrderMailer.with(user: self.owner_user, order: self, execution: self.executions.first,
  #       send_type: 'order_close').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
  #
  #     self.performers.each do |performer|
  #       OrderMailer.with(user: performer.user, order: self, execution: performer.execution,
  #         send_type: 'order_close').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
  #     end
  #
  #   end
  # end
end
