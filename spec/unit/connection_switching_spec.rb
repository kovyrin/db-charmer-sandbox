require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class FooModel < ActiveRecord::Base; end
class BarModel < ActiveRecord::Base; end

describe DbCharmer, "AR connection switching" do
  describe "in switch_connection_to method" do
    before(:all) do
      BarModel.hijack_connection!      
      @proxy = mock('proxy')
    end
    
    before do
      BarModel.db_charmer_connection_proxy = @proxy
      BarModel.connection.should be(@proxy)
    end

    it "should accept nil and reset connection to default" do
      BarModel.switch_connection_to(nil)
      BarModel.connection.should be(ActiveRecord::Base.connection)
    end
    
    it "should accept a string and generate an abstract class with connection factory" do
      BarModel.switch_connection_to('logs')
      BarModel.connection.object_id == DbCharmer::ConnectionFactory.connect('logs').object_id
    end
    
    it "should accept a symbol and generate an abstract class with connection factory" do
      BarModel.switch_connection_to(:logs)
      BarModel.connection.object_id.should == DbCharmer::ConnectionFactory.connect('logs').object_id
    end

    it "should accept a model and use its connection proxy value" do
      FooModel.switch_connection_to(:logs)
      BarModel.switch_connection_to(FooModel)
      BarModel.connection.object_id.should == DbCharmer::ConnectionFactory.connect('logs').object_id
    end
  end
end
