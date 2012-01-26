class Dog < ActiveRecord::Base
  db_magic
  belongs_to :user

  default_scope :include => :user
end
