class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  @@change_order_flag = false  
end
