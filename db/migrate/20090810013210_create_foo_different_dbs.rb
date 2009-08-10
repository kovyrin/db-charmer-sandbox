class CreateFooDifferentDbs < ActiveRecord::Migration
  def self.up
    create_table :foo_different_dbs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :foo_different_dbs
  end
end
