require "reform/form/coercion"

class OrderForm < Reform::Form
  feature Coercion

  include Reform::Form::ActiveModel
  include Reform::Form::ActiveModel::ModelReflections

  model :order

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

#def build_errors; end
end
