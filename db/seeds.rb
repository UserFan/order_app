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

unless EnumAction.any?
  EnumAction.create(name: 'Стандартные действия', action_name: 'default')
  EnumAction.create(name: 'Доступ к меню', action_name: 'menu_show')
end

unless EnumTypeAccess.any?
  EnumTypeAccess.create(id: 1, name: 'Запрещено')
  EnumTypeAccess.create(id: 2, name: 'Чтение')
  EnumTypeAccess.create(id: 3, name: 'Чтение/запись')
  EnumTypeAccess.create(id: 4, name: 'Полный доступ')
end

unless EnumResource.any?
  EnumResource.create(name: "Заявка", resource_name: "order", enum_action_id: 1)
  EnumResource.create(name: "Поручения", resource_name: "task", enum_action_id: 1)
  EnumResource.create(name: "Сотрудники", resource_name: "employee", enum_action_id: 1)
  EnumResource.create(name: "Профиль", resource_name: "profile", enum_action_id: 1)
  EnumResource.create(name: "Сервисное обслуживания", resource_name: "service_equipment", enum_action_id: 1)
  EnumResource.create(name: "Отчет по обслуживанию", resource_name: "report_cost_service", enum_action_id: 1)
  EnumResource.create(name: "ЭЦП", resource_name: "esp", enum_action_id: 1)
  EnumResource.create(name: "ЭЦП сертификаты", resource_name: "esp_cert", enum_action_id: 1)
  EnumResource.create(name: "Пользователи системы", resource_name: "user", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Типы оборудования\"", resource_name: "enum_type_equipment", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Оборудования\"", resource_name: "enum_equipment", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Должности\"", resource_name: "position", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Организация\"", resource_name: "organization_unit", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Банки\"", resource_name: "bank_unit", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"\"Категории", resource_name: "category", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Тип расхода\"", resource_name: "cost_type", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Провайдер\"", resource_name: "provider", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Сим карты\"", resource_name: "sim_card", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Статус\"", resource_name: "status", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Тип документов\"", resource_name: "type_document", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Тип объектов\"", resource_name: "type", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Ресурсы системы\"", resource_name: "enum_resource", enum_action_id: 1)
  EnumResource.create(name: "Справочник \"Действия в ресурсах системы\"", resource_name: "enum_action", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Заявки\"", resource_name: "menu_order", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Контрольные карточки\"", resource_name: "menu_task", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Структурное подразделения\"", resource_name: "menu_structural", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Торговые объекты\"", resource_name: "menu_shop", enum_action_id: 1)
  EnumResource.create(name: "Меню \"ЭЦП\"", resource_name: "menu_esp", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Сервисное обслуживания\"", resource_name: "menu_service", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Отчеты\"", resource_name: "menu_report", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Сотрудники\"", resource_name: "menu_employee", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Справочники\"", resource_name: "catalog", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Настройка доступа к системе\"", resource_name: "menu_access", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Пользователи системы\"", resource_name: "menu_user_access", enum_action_id: 1)
  EnumResource.create(name: "Меню \"Шаблон доступа\"", resource_name: "menu_templates_access", enum_action_id: 1)
end
