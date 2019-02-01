class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create
  after_create :create_order_control_user_send_mail
  after_update :change_order_change_user_send_mail

  belongs_to :category
  belongs_to :status
  belongs_to :shop, counter_cache: true
  belongs_to :employee

  has_many :performers, inverse_of: :order, dependent: :delete_all #, autosave: true
  has_many :users, through: :employee, foreign_key: :user_id, counter_cache: true

  has_many :executions, through: :performers, foreign_key: :order_id
  has_many :reworks, through: :executions

  validates :user_id, :date_open, :employee_id, :date_execution, :description, presence: true

  def control_user
    self.employee.user
  end

  def owner_user
    User.find(user_id)
  end

  def number_create
    Order.last.present? ? order_last_number = Order.last.id + 1 : order_last_number = 1
    self.order_number = "#{(category.name[0..1]).upcase}-#{Date.today.year}-#{order_last_number}" unless order_number.present?
  end

  private

  def create_order_control_user_send_mail
    OrderMailer.with(user: control_user, order: self,
      send_type: 'new_order_control').order_send_mail_to_user.deliver_later(wait: 10.seconds)
  end

  def change_order_change_user_send_mail

    OrderMailer.with(user: self.owner_user, order: self,
      send_type: 'order_change_owner').order_send_mail_to_owner_user.deliver_later(wait: 30.seconds) if self.status_id == Status::EXECUTION

    if self.date_closed.present?
      OrderMailer.with(user: self.owner_user, order: self, execution: self.executions.first,
        send_type: 'order_close').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)

      self.performers.each do |performer|
        OrderMailer.with(user: performer.user, order: self, execution: performer.execution,
          send_type: 'order_close').order_send_mail_to_user_coordination.deliver_later(wait: 10.seconds)
      end

    end
  end
end
