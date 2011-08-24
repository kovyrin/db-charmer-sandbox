require 'spec/spec_helper'

if DbCharmer.rails3?
  describe "ActiveRecord::Relation for a model with db_magic" do
    before do
      class User < ActiveRecord::Base
        db_magic :connection => nil
      end
    end

    it "should be created with correct default connection" do
      rel = User.on_db(:user_master).where("1=1")
      rel.db_charmer_connection.object_id.should == User.on_db(:user_master).connection.object_id
    end

    it "should switch the default connection when on_db called" do
      rel = User.where("1=1")
      rel_master = rel.on_db(:user_master)
      rel_master.db_charmer_connection.object_id.should_not == rel.db_charmer_connection.object_id
    end

    it "should keep default connection value when relation is cloned in chained calls" do
      rel = User.on_db(:user_master).where("1=1")
      rel.where("2=2").db_charmer_connection.object_id.should == rel.db_charmer_connection.object_id
    end

    it "should execute queries on the default connection" do
      rel = User.on_db(:user_master).where("1=1")

      User.on_db(:user_master).connection.should_receive(:select_all).and_return([User.first])
      User.connection.should_not_receive(:select_all)

      rel.first
    end
  end
end
