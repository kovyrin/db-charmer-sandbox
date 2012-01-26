class CreateDogs < ActiveRecord::Migration
  def self.up
    create_table :dogs do |t|
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dogs
  end
end
