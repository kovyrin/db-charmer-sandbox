require 'spec/spec_helper'

if DbCharmer.rails3?
  describe "ActiveRecord::Relation for a model with db_magic" do
    before do
      class Foo < ActiveRecord::Base
        db_magic :connection => nil
        set_table_name :users
      end
    end

    it "should be created with correct default connection" do
      rel = Foo.on_db(:user_master).where("1=1")
      rel.db_charmer_connection.object_id.should == Foo.on_db(:user_master).connection.object_id
    end

    it "should switch the default connection when on_db called" do
      rel = Foo.where("1=1")
      rel_master = rel.on_db(:user_master)
      rel_master.db_charmer_connection.object_id.should_not == rel.db_charmer_connection.object_id
    end

    it "should keep default connection value when relation is cloned in chained calls" do
      rel = Foo.on_db(:user_master).where("1=1")
      rel.where("2=2").db_charmer_connection.object_id.should == rel.db_charmer_connection.object_id
    end

    it "should execute select queries on the default connection" do
      rel = Foo.on_db(:user_master).where("1=1")

      Foo.on_db(:user_master).connection.should_receive(:select_all).and_return([])
      Foo.connection.should_not_receive(:select_all)

      rel.first
    end

    it "should execute delete queries on the default connection" do
      rel = Foo.on_db(:user_master).where("1=1")

      Foo.on_db(:user_master).connection.should_receive(:delete)
      Foo.connection.should_not_receive(:delete)

      rel.delete_all
    end

    it "should execute update_all queries on the default connection" do
      rel = Foo.on_db(:user_master).where("1=1")

      Foo.on_db(:user_master).connection.should_receive(:update)
      Foo.connection.should_not_receive(:update)

      rel.update_all("login = login + 'new'")
    end

    it "should execute update queries on the default connection" do
      rel = Foo.on_db(:user_master).where("1=1")
      user = Foo.create!(:login => 'login')

      Foo.on_db(:user_master).connection.should_receive(:update)
      Foo.connection.should_not_receive(:update)

      rel.update(user.id, :login => "foobar")
    end

    it "should return correct connection" do
      rel = Foo.on_db(:user_master).where("1=1")
      rel.connection.object_id.should == rel.db_charmer_connection.object_id
    end
  end
end
