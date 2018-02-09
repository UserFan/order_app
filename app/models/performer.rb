class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validates :order_id, :date_performance, presence: true

  validate :val_date_performance

  def val_date_performance

    if self.coexecutor?

      errors.add(:date_performance, "Дата меньше даты исполнения основного исполнителя") if self.date_performance < self.order.date_executor
    end


    if self.date_performance.present?
      errors.add(:date_performance, "Дата больше даты исполнения заявки") if self.date_performance > self.order.date_execution

      errors.add(:date_performance, "Дата меньше даты заявки") if (self.date_performance < self.order.date_open)

      errors.add(:date_performance, "Дата меньше даты срока исполнения заявки более 5 дней") if self.date_performance < (self.order.date_execution - 5.days)
    end


    if self.date_close_performance.present?

      errors.add(:date_close_performance, "Дата меньше даты заявки или закрытия заявки") if (self.date_close_performance < self.order.date_open) ||
                                                                                            (self.date_close_performance < self.order.date_execution) ||
                                                                                            (self.date_close_performance < self.date_performance)
    end

    if self.order.date_closed.present?
      errors.add(:date_performance, "Дата больше даты закрытия заявке") if self.date_performance > self.order.date_closed
      errors.add(:date_close_performance, "Дата больше даты закрытия заявке") if self.date_close_performance > self.order.date_closed
      errors.add(:date_performance, "Дата меньше даты закрытия заявке более чем 10 дней.") if self.date_performance < (self.order.date_closed - 10.days)
      errors.add(:date_close_performance, "Дата меньше даты закрытия заявке более чем 10 дней.") if self.date_close_performance < (self.order.date_closed - 10.days)
    end

  end
end
