require "active_support"
require "active_support/dependencies"

module RiactionGenie
  mattr_accessor :app_root

  def self.setup
    yield self
  end
end

require "riaction_genie/engine" if defined? Rails

