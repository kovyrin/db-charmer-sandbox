require 'spec/spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :login => "value for login",
      :password => "value for password"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
