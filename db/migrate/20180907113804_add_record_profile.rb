class AddRecordProfile < ActiveRecord::Migration[5.1]
  def change
    unless Profile.find_by(user_id: 1).present?
      Profile.create!(user_id: 1,
                      surname: 'Администратор',
                      first_name: 'системы',
                      mobile: '+70000000000',
                      position_id: 1)
    end
  end
end
