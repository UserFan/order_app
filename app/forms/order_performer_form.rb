class OrderPerformerForm

  include ActiveModel::Model
  include Virtus

  # Attributes (DSL provided by Virtus)
  #attribute :email, String
  #attribute :amount, Integer
  #attribute :paid, Boolean, default: false)

  # Access the expense record after it's saved
  #attr_reader :expense

  # Validations
  #validates :email, presence: true
  #validates :amount,  numericality: { only_integer: true, greater_than: 0 }

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    order = Order.create!(email: email)
    @performer = order.perfornmers.create!(amount: amount, paid: paid)
  end


end
