require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SpecMultiDbMigration < ActiveRecord::Migration
  db_magic :connection => :logs

  def self.up
    execute "UPDATE log_records SET level = 'debug'"
  end

  def self.down
    execute "UPDATE log_records SET level = 'blah'"
  end
end

class SpecMultiDbMigration2 < ActiveRecord::Migration
  def self.up
    execute "UPDATE log_records SET level = 'yo'"
    on_db(:logs) { execute "UPDATE log_records SET level = 'debug'" }
  end

  def self.down
    execute "UPDATE log_records SET level = 'bar'"
    on_db(:logs) { execute "UPDATE log_records SET level = 'blah'" }
  end
end

describe "Multi-db migractions" do
  describe "with db_magic calls" do
    it "should send all up requests to specified connection" do
      ActiveRecord::Base.connection.should_not_receive(:execute)
      DbCharmer::ConnectionFactory.connect(:logs).should_receive(:execute).with("UPDATE log_records SET level = 'debug'")
      SpecMultiDbMigration.migrate(:up)
    end

    it "should send all down requests to specified connection" do
      ActiveRecord::Base.connection.should_not_receive(:execute)
      DbCharmer::ConnectionFactory.connect(:logs).should_receive(:execute).with("UPDATE log_records SET level = 'blah'")
      SpecMultiDbMigration.migrate(:down)
    end
  end

  describe "with on_db blocks" do
    it "should send specified up requests to specified connection" do
      ActiveRecord::Base.connection.should_receive(:execute).with("UPDATE log_records SET level = 'yo'")
      DbCharmer::ConnectionFactory.connect(:logs).should_receive(:execute).with("UPDATE log_records SET level = 'debug'")
      SpecMultiDbMigration2.migrate(:up)
    end

    it "should send secified down requests to specified connection" do
      ActiveRecord::Base.connection.should_receive(:execute).with("UPDATE log_records SET level = 'bar'")
      DbCharmer::ConnectionFactory.connect(:logs).should_receive(:execute).with("UPDATE log_records SET level = 'blah'")
      SpecMultiDbMigration2.migrate(:down)
    end
  end
end
