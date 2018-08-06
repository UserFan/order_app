class ChangeStatuses < ActiveRecord::Migration[5.1]
  def change
    status = Status.find(3)
    status.update_attributes(name: 'Возобновлена')
  end
end
