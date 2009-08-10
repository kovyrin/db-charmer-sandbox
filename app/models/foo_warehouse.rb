class FooWarehouse < ActiveRecord::Base
  set_table_name :foo
  db_magic :on_db => :warehouse
end
