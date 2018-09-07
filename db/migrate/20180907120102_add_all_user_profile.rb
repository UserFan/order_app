class AddAllUserProfile < ActiveRecord::Migration[5.1]
  def change
    User.find_each do |user|
      if user.id == 1
        Profile.create!(user_id: user.id,
                        surname: 'Администратор',
                        first_name: 'системы',
                        mobile: '+70000000000',
                        position_id: 1)
      else
        Profile.create!(user_id: user.id,
                        surname: 'User',
                        first_name: 'User_name',
                        mobile: '+70000000000',
                        position_id: 1)
      end
    end
  end
end
