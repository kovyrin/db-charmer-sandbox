require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DbCharmer::AssociationProxy, "extending AR::Associations" do
  fixtures :users, :posts

  describe "in has_many associations" do
    before do
      @user = users(:bill)
    end
    
    it "should implement on_db proxy" do
      Post.on_db(:slave_db01).connection.should_receive(:select_all).and_return([ posts(:windoze) ])
      @user.posts.on_db(:slave_db01).first.should == posts(:windoze)
    end
    
    it "should actually proxy calls to the rails association proxy" do
      @user.posts.on_db(:slave_db01).count.should == @user.posts.count
    end
  end

  describe "in belongs_to associations" do
    before do
      @post = posts(:windoze)
    end

    it "should implement on_db proxy" do
      user = users(:bill)
      User.on_db(:slave_db01).connection.should_receive(:select_all).and_return([ user ])
      @post.user.on_db(:slave_db01).should == user
    end

    it "should actually proxy calls to the rails association proxy" do
      @post.user.on_db(:slave_db01).should == @post.user
    end
  end
end