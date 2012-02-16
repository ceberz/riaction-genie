class User < ActiveRecord::Base
  has_many :postcards
  
  riaction :profile, :type => :player, :custom => :id
  
end
