class Postcard < ActiveRecord::Base
  belongs_to :user
  
  riaction :event, :name => :write_a_postcard, :trigger => :create, :profile => :user
end
