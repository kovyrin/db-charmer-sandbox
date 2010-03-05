require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ActiveRecord in finder methods" do
  it "should send all queries to specified connection when :include is used" do
    pending "Not sure if this is a good idea"
    posts = Post.connection.select_all("SELECT * FROM posts")
    Post.on_db(:slave01).should_receive(:select_all).and_return(posts)
    User.connection.should_not_receive(:select_all)
    Post.on_db(:slave01).all(:include => :user)
  end
end
