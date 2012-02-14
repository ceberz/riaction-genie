Rails.application.routes.draw do
  get   "riaction_genie/:app_key/:profile_klass/:profile_id" => "riaction_genie/events#index" , :as => :riaction_genie_events
  post  "riaction_genie/:app_key/:profile_klass/:profile_id" => "riaction_genie/events#create" , :as => :riaction_genie_events
end