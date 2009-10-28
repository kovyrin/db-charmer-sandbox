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

    it "should work with long scope chains" do
      Post.on_db(:slave_db01).connection.should_not_receive(:select_all)
      Post.on_db(:slave_db01).connection.should_receive(:select_value).and_return(5)
      Post.on_db(:slave_db01).windows_posts.count.should == 5
    end

    it "should work with associations" do
      users(:bill).posts.on_db(:slave_db01).windows_posts.all.should == users(:bill).posts.windows_posts
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

    it "should work with long scope chains" do
      Post.on_db(:slave_db01).connection.should_not_receive(:select_all)
      Post.on_db(:slave_db01).connection.should_receive(:select_value).and_return(5)
      Post.windows_posts.on_db(:slave_db01).count.should == 5
    end

    it "should work with associations" do
      users(:bill).posts.windows_posts.on_db(:slave_db01).all.should == users(:bill).posts.windows_posts
    end
  end
end
