require 'spec_helper'

# ActiveRecord reconnecting is necessary in a pre-forking Rack server like Unicorn.
#Connections need to be destroyed pre-fork, and reconnected post-fork
describe "ActiveRecord reconnecting" do
  context "querying on a model (LogRecord) that has default scope" do
    before do
      @id = Dog.create!(:user => User.create!).id
    end

    it "should not cause an exception after reconnecting" do
      Dog.find_by_id(@id, :include => :user)

      ActiveRecord::Base.connection_handler.clear_all_connections!
      ActiveRecord::Base.connection_handler.verify_active_connections!
      # The below line of code would make this test pass
      # Dog.default_scoping.first.db_charmer_connection = ActiveRecord::Base.connection_handler.retrieve_connection(Dog)

      Dog.find_by_id(@id, :include => :user)
    end

  end
end