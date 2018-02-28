class OrderForm < Reform::Form
  include Reform::Form::ActiveModel
  include Reform::Form::ActiveModel::FormBuilderMethods
  include Reform::Form::ActiveModel::ModelReflections

  model :order

  property :category_id
  property :date_open
  property :date_execution
  property :shop_id
  property :short_descript
  property :description
  property :date_closed
  property :user_id
  property :status_id
  property :photos

  validates :category_id, :date_open, :date_execution, :shop_id, :short_descript, :user_id, :status_id, presence: true

#def build_errors; end
end
