class OrderForm

  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  include Virtus

  attr_accessor :order, :performer, :category, :date_open, :date_execution, :shop_id, :short_descript,
   :description,:date_closed, :user_id, :status_id, :photos
  # Attributes (DSL provided by Virtus)
  #attribute :email, String
  #attribute :amount, Integer
  #attribute :paid, Boolean, default: false)

  # Access the expense record after it's saved
  #attr_reader :expense

  # Validations
  #validates :email, presence: true
  #validates :amount,  numericality: { only_integer: true, greater_than: 0 }

  delegate :performers, :performers_attributes=, :to => :order, :prefix => true, :allow_nil => false

  def performers
    order.performers
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Order")
  end

  def save
    if valid?
      #persist!
      true
    else
      false
    end
  end

  private

  def persist!
    #order = Order.create!(email: email)
    #@performer = order.perfornmers.create!(amount: amount, paid: paid)
  end


end
