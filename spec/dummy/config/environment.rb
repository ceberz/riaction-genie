# Load the rails application
require File.expand_path('../application', __FILE__)

YAML::ENGINE.yamler = 'syck'

# Initialize the rails application
Dummy::Application.initialize!
