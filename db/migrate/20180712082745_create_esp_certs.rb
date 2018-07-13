class CreateEspCerts < ActiveRecord::Migration[5.1]
  def change
    create_table :esp_certs do |t|
      t.references  :esp,                     null: false,      default: 0
      t.datetime :date_start_esp,             null: false
      t.datetime :date_end_esp,               null: false
      t.string :serial_num_esp
      t.datetime :date_start_rsa,             null: false
      t.datetime :date_end_rsa,               null: false
      t.string :rsa_serial
      t.timestamps
    end
  end
end
