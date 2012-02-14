# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "riaction_genie/version"

Gem::Specification.new do |s|
  s.name        = "riaction_genie"
  s.version     = RiactionGenie::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["git@chriseberz.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "riaction_genie"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "spec"]
  
  s.add_runtime_dependency "rake", '0.9.2'
  s.add_runtime_dependency "rails", "3.0.11"
  s.add_runtime_dependency "ruby-iactionable", "0.0.2"
  s.add_runtime_dependency "riaction", "1.1.0"
  s.add_runtime_dependency "haml"
end
