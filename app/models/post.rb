class Post < ActiveRecord::Base
  db_magic :slave => :slave01
  belongs_to :user

  named_scope :windows_posts, :conditions => "title like '%win%'"
end
