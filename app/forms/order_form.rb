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
