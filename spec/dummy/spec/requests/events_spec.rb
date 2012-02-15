require 'spec_helper'

describe "Riaction Events" do
  before do
    @mocked_api = mock("mocked API")
    @iactionable_creds = IActionable::Api.settings
    @user = User.create(:email => 'zortnac@pah.com')
    @postcard = Postcard.create(:user => @user, :content => "wish you were here")
    
    IActionable::Api.stub!(:new).and_return(@mocked_api)
  end
  
  describe "GET /riaction_genie/:app_key/:profile_klass/:profile_id" do
    describe "with an invalid app_key" do
      it "should respond unauthorized" do
        get riaction_genie_events_path(:app_key => 'bogus', :profile_klass => 'users', :profile_id => @user.id)
        response.status.should be(401)
      end
    end
    
    describe "with an non-existant class described" do
      it "should respond not found" do
        get riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'dogs', :profile_id => @user.id)
        response.status.should be(404)
      end
    end
    
    describe "with an non-existant instance of the class described" do
      it "should respond not found" do
        get riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => 99999)
        response.status.should be(404)
      end
    end
    
    describe "when the class described in the route is not a riaction profile" do
      it "should respond not found" do
        get riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'postcards', :profile_id => @postcard.id)
        response.status.should be(404)
      end
    end
    
    it "should respond with success" do
      get riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id)
      response.status.should be(200)
    end
  end
  
  describe "POST /riaction_genie" do
    before do
      @params = {
        :profile_type => :player,
        :event_name => :write_a_postcard,
        :event_params => "foo=bar&apple=pi"
      }
    end
    
    describe "with an invalid app_key" do
      it "should respond unauthorized" do
        xhr :post, riaction_genie_events_path(:app_key => 'bogus', :profile_klass => 'users', :profile_id => @user.id), @params
        response.status.should be(401)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "without the profile type" do
      it "should respond not found" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params.merge(:profile_type => nil)
        response.status.should be(422)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "without the event name" do
      it "should respond not found" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params.merge(:event_name => nil)
        response.status.should be(422)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "with an non-existant class described" do
      it "should respond not found" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'dogs', :profile_id => @user.id), @params
        response.status.should be(404)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "with an non-existant instance of the class described" do
      it "should respond not found" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => 99999), @params
        response.status.should be(404)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "when the class described in the route is not a riaction profile" do
      it "should respond not found" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'postcards', :profile_id => @postcard.id), @params
        response.status.should be(404)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "with a profile type that doesn't exist" do
      before do
        @params[:profile_type] = :bogus
      end
      
      it "should respond with unprocessable entity" do
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params
        response.status.should be(422)
      end
      
      it "should not try to create any event" do
        @mocked_api.should_not_receive(:log_event)
      end
    end
    
    describe "with optional event params" do
      it "should create the event with the optional params" do
        @mocked_api.should_receive(:log_event).once.with( @params[:profile_type].to_s,
                                                          @user.riaction_profile_keys[@params[:profile_type]].first.first.to_s,
                                                          @user.riaction_profile_keys[@params[:profile_type]].first.last.to_s,
                                                          @params[:event_name].to_s,
                                                          Rack::Utils.parse_nested_query(@params[:event_params]) )
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params
      end
      
      it "should respond created" do
        @mocked_api.stub!(:log_event)
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params
        response.status.should be(201)
      end
    end
    
    describe "without optional event params" do
      before do
        @params[:event_params] = nil
      end
      
      it "should create the event with the optional params" do
        @mocked_api.should_receive(:log_event).once.with( @params[:profile_type].to_s,
                                                          @user.riaction_profile_keys[@params[:profile_type]].first.first.to_s,
                                                          @user.riaction_profile_keys[@params[:profile_type]].first.last.to_s,
                                                          @params[:event_name].to_s,
                                                          Rack::Utils.parse_nested_query(@params[:event_params]) )
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params
      end
      
      it "should respond created" do
        @mocked_api.stub!(:log_event)
        xhr :post, riaction_genie_events_path(:app_key => @iactionable_creds.app_key, :profile_klass => 'users', :profile_id => @user.id), @params
        response.status.should be(201)
      end
    end
  end  
end
