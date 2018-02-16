class Cashbox < ApplicationRecord

  belongs_to :apc
  belongs_to :bank_unit
  belongs_to :display
  belongs_to :fiscal
  belongs_to :keyboard
  belongs_to :organization_unit
  belongs_to :scaner
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :shop

  has_many :cash_images, dependent: :restrict_with_error

  accepts_nested_attributes_for :cash_images, reject_if: :all_blank, allow_destroy: true

  validates :shop_id, :display_client_id, presence: true

  def cash_full
    sys_unit = %Q{#{self.system_unit.motherboard}/
                #{self.system_unit.cpu}/
                #{self.system_unit.ram}/
                #{self.system_unit.hdd}/
                #{self.system_unit.os}<br>}
    str = <<-STR
          <ul><li><b>Юридическое лицо:</b> #{self.organization_unit.name}</li>
            <ul><li><b>Системный блок:</b> #{sys_unit}</li>
            <li><b>Дисплей:</b> #{self.display.name}</li>
            <li><b>Калавиатура:</b> #{self.keyboard.name}</li>
            <li><b>Дисплей покупателя:</b> #{self.display_clien_name}</li>
            <li><b>Сканер:</b> #{self.scaner.name}</li>
            <li><b>Банковский терминал:</b> #{self.bank_unit.name}</li>
            <li><b>Стабилизатор:</b> #{self.stabilizer.name}</li>
            <li><b>ИБП:</b> #{self.apc.name}</li>
            <li><b>Фискальный апарат:</b> #{self.fiscal.name}</li>
            <li><b>Коментарий:</b> #{self.comment}</li></ul></ul>
         STR
    return str

  end

  def display_clien_name
    name_display = Display.find(self.display_client_id).name
    return name_display

  end

end
