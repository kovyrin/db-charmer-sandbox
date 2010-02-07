require 'test_helper'

class NamedScopeTest < ActiveSupport::TestCase
  fixtures :users, :posts
  
  def setup
    Post.switch_connection_to(nil)
    User.switch_connection_to(nil)
  end
  
  #-------------------------------------------------------------------------------------------------------

  test "Named scopes when prefixed by on_db should work on the proxy" do
    assert_equal(Post.on_db(:slave01).windows_posts, Post.windows_posts)
  end
  
  test "Named scopes when prefixed by on_db should actually run queries on the specified db" do
    Post.on_db(:slave01).connection.expects(:select_all).once.returns([])
    Post.on_db(:slave01).windows_posts.all
    Post.windows_posts.all
  end

  test "Named scopes when prefixed by on_db should work with long scope chains" do
    Post.on_db(:slave01).connection.expects(:select_all).never
    Post.on_db(:slave01).connection.expects(:select_value).returns(5)
    assert_equal(Post.on_db(:slave01).windows_posts.count, 5)
  end

  test "Named scopes when prefixed by on_db should work with associations" do
    assert_equal(users(:bill).posts.on_db(:slave01).windows_posts.all, users(:bill).posts.windows_posts)
  end
  
  #-------------------------------------------------------------------------------------------------------

  test "Named scopes when postfixed by on_db should work on the proxy" do
    assert_equal(Post.windows_posts.on_db(:slave01), Post.windows_posts)
  end

  test "Named scopes when postfixed by on_db should actually run queries on the specified db" do
    assert_not_equal(Post.on_db(:slave01).connection.object_id, Post.connection.object_id)
    Post.on_db(:slave01).connection.expects(:select_all).returns([])
    Post.windows_posts.on_db(:slave01).all
    Post.windows_posts.all
  end

  test "Named scopes when postfixed by on_db should work with long scope chains" do
    Post.on_db(:slave01).connection.expects(:select_all).never
    Post.on_db(:slave01).connection.expects(:select_value).returns(5)
    assert_equal(Post.windows_posts.on_db(:slave01).count, 5)
  end

  test "Named scopes when postfixed by on_db should work with associations" do
    assert_equal(users(:bill).posts.windows_posts.on_db(:slave01).all, users(:bill).posts.windows_posts)
  end

end
