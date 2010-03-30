require 'spec/spec_helper'

describe Event, "sharded model" do
  it "should respond to shard_for method" do
    Event.should respond_to(:shard_for)
  end
end
