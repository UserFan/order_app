class ShopWeigher < ApplicationRecord
  belongs_to :weigher
  belongs_to :shop


  def shop_weigher_full
    str = <<-STR
          <ul><li><b>Весы марки:</b> #{self.weigher.name}</li>
            <ul><li><b>IP-адрес:</b> #{self.ip_address}</li>
            <li><b>Коментарий:</b> #{self.comment}</li></ul></ul>
         STR
    return str

  end

end
