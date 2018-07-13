class CashCash < ApplicationRecord
  # self.establish_connection(connect_timeout: 5,
  #                               adapter:  "postgresql",
  #                               host:     "192.16.103.33",
  #                               username: "postgres",
  #                               password: "postgres",
  #                               database: "set")
  self.table_name = "cash_cash"

  def readonly?
    true
  end
end
