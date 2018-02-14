class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  belongs_to :category
  belongs_to :status
  belongs_to :shop
  #has_many :physicians, through: :appointments

  has_many :performers, inverse_of: :order, dependent: :restrict_with_error
  has_many :users, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :order_id
  accepts_nested_attributes_for :performers, reject_if: :all_blank, allow_destroy: true

  validates :user_id, :date_open, :date_execution, :short_descript, presence: true

  validate :val_date_execution


  def count_executors
    self.performers.where(coexecutor: false).count
  end

  def date_executor
    performer = self.performers.find_by(coexecutor: false)
    #return self.performers.date_performance if self.performers.executor?
    if performer.date_performance_changed?
      return performer.date_performance_change[0]
    else
      return performer.date_performance
    end
  end

  def val_date_execution
    if self.date_execution.present?
      errors.add(:date_execution, "Дата меньше даты заявки") if self.date_execution < self.date_open

      errors.add(:date_execution, "Дата больше даты заявки более 30 дней") if self.date_execution > (self.date_open + 30.days)
    end

    if self.date_closed.present?
      errors.add(:date_closed, "Дата меньше даты срока исполнения заявки") if self.date_closed < self.date_execution
      errors.add(:date_closed, "Дата меньше даты заявки") if self.date_closed < self.date_open
      errors.add(:date_closed, "Дата больше даты заявки более 30 дней") if self.date_closed > (self.date_open + 30.days)
    end
  end

  def control_name

    User.find(self.user_id).full_name

  end
end
