require "reform/form/coercion"

class OrderForm < Reform::Form
  feature Coercion

  include Reform::Form::ActiveModel
  include Reform::Form::ActiveModel::ModelReflections

  property :category_id
  property :date_open, type: Types::Form::DateTime
  property :date_execution, type: Types::Form::DateTime
  property :shop_id
  property :short_descript
  property :description
  property :date_closed, type: Types::Form::DateTime
  property :user_id
  property :status_id
  property :photos

  validates :category_id, :date_open, :date_execution, :shop_id, :short_descript, :user_id, :status_id, presence: true

  validate :val_date_execution

  collection :performers,  prepopulator: :build_performer,
                           populator: :performer_populator do

    include NestedForm

    property :user_id
    property :date_performance, type: Types::Form::DateTime
    property :date_close_performance, type: Types::Form::DateTime
    property :coexecutor
    property :message
    property :comment

    validates :user_id, :date_performance, presence: true

  end

  validate :valid_performer
  validate :valid_date_performance

  private

    def valid_performer
      errors.add(:coexecutor, "Ответсвенный исполнитель может быть только один") if count_performer > 1
      errors.add(:coexecutor, "Ответсвенный исполнитель не определен") if count_performer == 0
    end

    def valid_date_performance
      if date_executor_performance != 0
        performers.each do |performer|
          errors.add(:date_performance, "Срок исполнения у ответсвенного исполнителя некоректен") if !(date_executor_performance.between?(date_open, date_execution)) && (performer.coexecutor == '0')
          errors.add(:date_performance, "Срок исполнения у соисполнителя некоректен") if !(performer.date_performance.between?(date_open, date_executor_performance)) && (performer.coexecutor == '1')
        end
      end
    end

    def date_executor_performance
     count_executor = 0
     date_start_executor = 0
     performers.each do |performer|
       if performer.coexecutor == '0'
         count_executor += 1
         count_executor == 1 ?  date_start_executor = performer.date_performance : date_start_executor = 0
       end
     end
     return date_start_executor
    end

    def count_performer
      count_executor = 0
      performers.each do |performer|
        count_executor += 1 if performer.coexecutor == '0'
      end
      return count_executor
    end

    def build_performer(*)
      performers << Performer.new if performers.blank?
    end

    def performer_populator(fragment:, collection:, **)

      item = collection.find_by(id: fragment['id']) unless fragment['id'].blank?

      if fragment['_destroy'] == '1'
        collection.delete(item) if item
        return skip!
      end
        item ? item : collection.append(Performer.new)
    end

    def val_date_execution
      if date_execution.present?
        errors.add(:date_execution, "Дата меньше даты заявки") if date_execution < date_open
        errors.add(:date_execution, "Дата больше даты заявки более 30 дней") if date_execution > (date_open + 30.days)
      end

      if date_closed.present?
        errors.add(:date_closed, "Дата меньше даты срока исполнения заявки") if date_closed < date_execution
        errors.add(:date_closed, "Дата меньше даты заявки") if date_closed < date_open
        errors.add(:date_closed, "Дата больше даты заявки более 30 дней") if date_closed > (date_open + 30.days)
      end
    end

end
