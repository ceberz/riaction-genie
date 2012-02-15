module RiactionGenie
  class EventsController < ::ApplicationController
    before_filter :check_app_key
    before_filter :set_riaction_profile
    
    def index
      
    end
    
    def create
      if @profile.riaction_profile_keys.has_key?(params[:profile_type].try(:to_sym)) && params[:event_name]
        IActionable::Api.new.log_event( params[:profile_type].to_s,
                                        @profile.riaction_profile_keys[params[:profile_type].to_sym].first.first.to_s,
                                        @profile.riaction_profile_keys[params[:profile_type].to_sym].first.last.to_s,
                                        params[:event_name].to_s,
                                        Rack::Utils.parse_nested_query(params[:event_params]) )
        respond_to do |format|
          format.json {render :nothing => true, :status => :created}
        end
      else
        respond_to do |format|
          format.json {render :nothing => true, :status => :unprocessable_entity}
        end
      end
    end
    
    private
    
    def check_app_key
      unless IActionable::Api.settings.app_key == params[:app_key]
        respond_to do |format|
          format.html {render :nothing => true, :status => :unauthorized}
        end
      end
    end
    
    def set_riaction_profile
      @profile = params[:profile_klass].singularize.capitalize.constantize.find_by_id!(params[:profile_id])
      raise NameError.new unless @profile.class.riactionary? && @profile.class.riaction_profile?
    rescue ActiveRecord::RecordNotFound, NameError => e
      respond_to do |format|
        format.html {render :nothing => true, :status => :not_found}
      end
    end
  end
end