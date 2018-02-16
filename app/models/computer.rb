class Computer < ApplicationRecord

  belongs_to :commouse
  belongs_to :display
  belongs_to :keyboard
  belongs_to :stabilizer
  belongs_to :system_unit
  belongs_to :printer
  belongs_to :shop

  validates :shop_id, presence: true

  def computer_full
    sys_unit = %Q{#{self.system_unit.motherboard}/
                #{self.system_unit.cpu}/
                #{self.system_unit.ram}/
                #{self.system_unit.hdd}/
                #{self.system_unit.os}<br>}
    str = <<-STR
          <ul><li><b>Компьютерное оборудование:</b></li>
            <ul><li><b>Системный блок:</b> #{sys_unit}</li>
            <li><b>Дисплей:</b> #{self.display.name}</li>
            <li><b>Калавиатура:</b> #{self.keyboard.name}</li>
            <li><b>Манипулятор (мышь):</b> #{self.commouse.name}</li>
            <li><b>Принтер (МФУ):</b> #{self.printer.name}</li>
            <li><b>Стабилизатор:</b> #{self.stabilizer.name}</li>
            <li><b>TeamViewer(ID):</b> #{self.teamview_id}</li>
            <li><b>IP-адрес:</b> #{self.ip_address}</li>
            <li><b>Коментарий:</b> #{self.comment}</li></ul></ul>
         STR
    return str

  end

end
