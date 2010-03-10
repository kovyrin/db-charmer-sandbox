require 'spec/spec_helper'

describe 'AbstractAdapter' do
  it "should respond to connection_name accessor" do
    ActiveRecord::Base.connection.respond_to?(:connection_name).should be_true
  end

  it "should have connection_name read accessor working" do
    DbCharmer::ConnectionFactory.generate_abstract_class('blah').connection.connection_name.should == 'blah'
    DbCharmer::ConnectionFactory.generate_abstract_class('foo').connection.connection_name.should == 'foo'
    DbCharmer::ConnectionFactory.generate_abstract_class('abrakadabra').connection.connection_name.should == 'abrakadabra'
    ActiveRecord::Base.connection.connection_name.should be_nil
  end

  it "should append connection name to log records on non-default connections" do
    User.switch_connection_to nil
    default_message = User.connection.send(:format_log_entry, 'hello world')
    switched_message = User.on_db(:slave01).connection.send(:format_log_entry, 'hello world')
    switched_message.should_not == default_message
    switched_message.should match(/slave01/)
  end
end
