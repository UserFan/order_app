class CreateVersionUpdateLog < ActiveRecord::Migration[5.1]
  def change
    create_table :version_update_logs do |t|
      t.references  :shop,                     null: false, default: 0
      t.datetime    :date_log,                 null: false
      t.boolean     :result_update,            default: false
      t.string      :text_log
      t.timestamps
    end
  end
end
