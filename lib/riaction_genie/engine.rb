require 'rails'
require "active_record"
require 'riaction_genie/riaction_genie'

module RiactionGenie
  class Engine < Rails::Engine  
    rake_tasks do
      load "tasks/riaction_genie.rake"
    end
    
    generators do
    end
    
    initializer "riaction_genie.load_app_instance_data" do |app|
      RiactionGenie.setup do |config|
        config.app_root = app.root
      end
    end
  end
end