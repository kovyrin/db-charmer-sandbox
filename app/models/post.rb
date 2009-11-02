class Post < ActiveRecord::Base
  belongs_to :user

  named_scope :windows_posts, :conditions => "title like '%win%'"
end
