require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Named scopes" do
  fixtures :users, :posts

  describe "prefixed by on_db" do
    it "should work on the proxy" do
      Post.on_db(:slave_db01).windows_posts.should == Post.windows_posts
    end

    it "should actually run queries on the specified db" do
      Post.on_db(:slave_db01).connection.should_receive(:select_all).once.and_return([])
      Post.on_db(:slave_db01).windows_posts.all
      Post.windows_posts.all
    end
  end

  describe "postfixed by on_db" do
    it "should work on the proxy" do
      Post.windows_posts.on_db(:slave_db01).should == Post.windows_posts
    end

    it "should actually run queries on the specified db" do
      Post.on_db(:slave_db01).connection.should_receive(:select_all).once.and_return([])
      Post.windows_posts.on_db(:slave_db01).all
      Post.windows_posts.all
    end
  end
end
