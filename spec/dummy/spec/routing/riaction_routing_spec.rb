require "spec_helper"

describe 'Riaction' do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/riaction_genie/12345678/users/1" }.should route_to( :controller => "riaction_genie/events", 
                                                                :action => "index",
                                                                :api_key => "12345678",
                                                                :profile_klass => "users",
                                                                :profile_id => "1" )
    end
    
    it "recognizes and generates #create" do
      { :post => "/riaction_genie/12345678/users/1" }.should route_to(:controller => "riaction_genie/events", 
                                                                :action => "create",
                                                                :api_key => "12345678",
                                                                :profile_klass => "users",
                                                                :profile_id => "1")
    end
  end
end
