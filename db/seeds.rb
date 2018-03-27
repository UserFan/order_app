# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Role.any?
  Role.create(id: 1, name: 'Пользователь')
  Role.create(id: 2, name: 'Руководитель')
  Role.create(id: 3, name: 'Модератор')
  Role.create(id: 4, name: 'Администратор системы')
end

unless Status.any?
  Status.create(id: 1, name: 'Исполнен', role: [2,3,4])
  Status.create(id: 2, name: 'Исполняется', role: [2,3,4])
  Status.create(id: 3, name: 'Смена исполнителя', role: [2,3,4])
  Status.create(id: 4, name: 'Закрыта', role: [2,3,4])
  Status.create(id: 5, name: 'На согласовании', role: [2,3,4])
  Status.create(id: 6, name: 'Новое', role: [2,3,4])
  Status.create(id: 7, name: 'На дороботке', role: [2,3,4])
end

Position.create(id:1, name: 'Администратор системы') unless Position.any?

unless User.any?
  User.create(id: 1,
              full_name: 'Администратор системы',
              position_id: 1,
              email: 'habfanis@mail.ru',
              mobile: '+70000000000',
              role_id: 4,
              admin: true,
              password: 'fan2533hq')
end
