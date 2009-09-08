class Post < ActiveRecord::Base
  db_magic :slave => :slave01
  belongs_to :user
end
