class User < ActiveRecord::Base
  has_many :postcards
  
  riaction :profile, :type => :player, :custom => :id
  
  def display_name
    email
  end
end
