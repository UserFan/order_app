require "reform/form/coercion"

class OrderForm < Reform::Form
  feature Coercion

  #include Reform::Form::ActiveModel
  include Reform::Form::ActiveRecord
  include Reform::Form::ActiveModel::ModelReflections

  model :order

  property :category_id
  property :date_open, type: Types::Params::DateTime
  property :date_execution, type: Types::Params::DateTime
  property :shop_id
  property :short_descript
  property :description
  property :date_closed, type: Types::DateTime
  property :user_id
  property :status_id
  property :photos
  property :order_number

  validates :category_id, :date_open, :date_execution, :shop_id, :short_descript, :user_id, :status_id, presence: true

  validate :val_date_execution


  collection :performers,  prepopulator: :build_performer,
                           populator: :performer_populator do

    include NestedForm
    include Coercion

    model :performer

    property :user_id
    property :date_performance, type: Types::Params::DateTime
    property :date_close_performance, type: Types::Params::DateTime
    property :coexecutor
    property :message
    property :comment

    validates :user_id, :date_performance, presence: true

  end

  validate :valid_date_performance
  validate :valid_performer

  private

    def valid_performer
      if performers.any?
        errors.add(:base, :coexecutor_error) if count_performer > 1
        errors.add(:base, :executor_not_error) if count_performer == 0
        self.status_id = Status::EXECUTION
      else
        self.status_id = Status::NEW
      end
    end

    def valid_date_performance
      if (date_executor_performance.present?) && (date_open.present?) && (date_execution.present?)
        performers.each do |performer|
          if !(date_executor_performance.between?(date_open, date_execution)) && !(performer.coexecutor).to_bool
            performer.errors.add(:date_performance, :date_executor_error)
            errors.add(:base, :date_executor_error)
          end
          if (performer.date_performance.present?) && (performer.coexecutor).to_bool
            unless (performer.date_performance.between?(date_open, date_executor_performance))
              performer.errors.add(:date_performance, :date_coexecutor_error)
              errors.add(:base, :date_coexecutor_error)
            end
          end
        end
      end
    end

    def date_executor_performance
     count_executor = 0
     date_start_executor = ""
     performers.each do |performer|
       if !(performer.coexecutor).to_bool
         count_executor += 1
         # count_executor == 1 ? date_start_executor = performer.date_performance : date_start_executor = ""
         date_start_executor = (count_executor == 1 ? performer.date_performance : "")
       end
     end
     return date_start_executor
    end

    def count_performer
      count_executor = 0
      count_coexecutor = 0
      set_user = nil
      performers.each do |performer|
        !(performer.coexecutor).to_bool ? count_executor += 1 : count_coexecutor += 1
        if performer.user_id == set_user
          performer.errors.add(:user_id, :user_error)
          errors.add(:base, :user_error)
        else
          set_user = performer.user_id
        end
        performer.errors.add(:coexecutor, :coexecutor_error) if count_executor > 1
        performer.errors.add(:coexecutor, :executor_not_error) if count_coexecutor == performers.count
      end
      count_executor
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
        errors.add(:date_execution, :date_execution_less) if date_execution < date_open
        errors.add(:date_execution, :date_execution_more_30_days) if date_execution > (date_open + 30.days)
      end

      if date_closed.present?
        errors.add(:date_closed, :date_closed_error) if (date_closed.between?(date_open, date_execution))
        errors.add(:date_closed, :date_closed_less_open) if date_closed < date_open
        errors.add(:date_closed, :date_closed_more_30_days) if date_closed > (date_execution + 30.days)
      end
      #binding.pry
    end



end
