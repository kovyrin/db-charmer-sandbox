require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "DbCharmer::AssociationProxy extending AR::Associations" do
  fixtures :users, :posts

  it "should add proxy? => true method" do
    users(:bill).posts.proxy?.should be_true
  end

  describe "in has_many associations" do
    before do
      @user = users(:bill)
      @posts = @user.posts.all
      Post.switch_connection_to(:logs)
      User.switch_connection_to(:logs)
    end

    after do
      Post.switch_connection_to(nil)
      User.switch_connection_to(nil)
    end

    it "should implement on_db proxy" do
      Post.connection.should_not_receive(:select_all)
      User.connection.should_not_receive(:select_all)

      Post.on_db(:slave01).connection.should_receive(:select_all).and_return(@posts)
      assert_equal @posts, @user.posts.on_db(:slave01)
    end

    it "on_db should work in prefix mode" do
      Post.connection.should_not_receive(:select_all)
      User.connection.should_not_receive(:select_all)

      Post.on_db(:slave01).connection.should_receive(:select_all).and_return(@posts)
      assert_equal @posts, @user.on_db(:slave01).posts
    end

    it "should actually proxy calls to the rails association proxy" do
      Post.switch_connection_to(nil)
      @user.posts.on_db(:slave01).count.should == @user.posts.count
    end
  end

  describe "in belongs_to associations" do
    before do
      @post = posts(:windoze)
      @user = users(:bill)
      User.switch_connection_to(:logs)
      User.connection.object_id.should_not == Post.connection.object_id
    end

    after do
      User.switch_connection_to(nil)
    end

    it "should implement on_db proxy" do
      pending
      Post.connection.should_not_receive(:select_all)
      User.connection.should_not_receive(:select_all)
      User.on_db(:slave01).connection.should_receive(:select_all).once.and_return([ @user ])
      @post.user.on_db(:slave01).should == @post.user
    end

    it "on_db should work in prefix mode" do
      pending
      Post.connection.should_not_receive(:select_all)
      User.connection.should_not_receive(:select_all)
      User.on_db(:slave01).connection.should_receive(:select_all).once.and_return([ @user ])
      @post.on_db(:slave01).user.should == @post.user
    end

    it "should actually proxy calls to the rails association proxy" do
      User.switch_connection_to(nil)
      @post.user.on_db(:slave01).should == @post.user
    end
  end
end
