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
  Status.create(id: 1, name: 'Исполнена', role: [2,3,4])
  Status.create(id: 2, name: 'Исполняется', role: [2,3,4])
  Status.create(id: 3, name: 'Возобновлена', role: [2,3,4])
  Status.create(id: 4, name: 'Закрыта', role: [2,3,4])
  Status.create(id: 5, name: 'На согласовании', role: [2,3,4])
  Status.create(id: 6, name: 'Новая', role: [2,3,4])
  Status.create(id: 7, name: 'На доработке', role: [2,3,4])
  Status.create(id: 8, name: 'Согласована', role: [2,3,4])
  Status.create(id: 9, name: 'Снята с контроля(исполнения)', role: [2,3,4])
  Status.create(id: 10, name: 'Исполнена частично', role: [2,3,4])
  Status.create(id: 11, name: 'Не исполнена', role: [2,3,4])
end

unless Type.any?
  Type.create(id: 1, name: 'Магазин')
  Type.create(id: 2, name: 'Павильон')
  Type.create(id: 3, name: 'Магазин (самообслуживания)')
  Type.create(id: 4, name: 'Структурное подразделение')
end

Position.create(id:1, name: 'Администратор системы') unless Position.any?

unless User.any?
  User.create(id: 1,
              email: 'habfanis@mail.ru',
              role_id: 4,
              admin: true,
              password: 'fan2533hq')
  user = User.first
  user.create_profile!(surname: "Администратор",
                       first_name: "системы",
                       mobile: "+70000000000",
                       date_recruitment: "01.01.1900".to_date)
end
