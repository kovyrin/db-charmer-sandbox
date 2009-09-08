require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Named scopes" do
  fixtures :users, :posts
  it "should work with on_db proxy" do
    Post.on_db(:slave_db01).windows_posts.should == Post.windows_posts
  end
end
