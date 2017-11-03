# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Role.present?
  Role.create(name: 'Пользователь')
  Role.create(name: 'Руководитель')
  Role.create(name: 'Модератор')
  Role.create(name: 'Администратор системы')
end

Position.create(name: 'Администратор системы') if Position.present?

if User.present?
  User.create(full_name: 'Администратор системы',
               position_id: 1,
               email: 'habfanis@mail.ru',
               mobile: '+70000000000',
               role_id: 4,
               admin: true,
               password: 'fan2533hq')
end
