class CreateLogRecords < ActiveRecord::Migration
  def self.up
    on_db :logs do
      create_table :log_records do |t|
        t.string :level
        t.string :message
        t.timestamps
      end
    end
  end

  def self.down
    on_db :logs do
      drop_table :log_records
    end
  end
end
