# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid/metastamp/version"

Gem::Specification.new do |s|
  s.name        = "mongoid-metastamp"
  s.version     = Mongoid::Metastamp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Gumeson"]
  s.email       = ["gumeson@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/mongoid-metastamp"
  s.summary     = %q{ Store and query more useful information about your Mongoid timestamps. }
  s.description = %q{ Provides Mongoid with enhanced meta-timestamps that store additional parsed time metadata, allowing more powerful querying on specific time fields and across normalized time zones. }

  s.rubyforge_project = "mongoid-metastamp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("mongoid", "~> 2.4")
  s.add_development_dependency("rake", "~> 0.9")
  s.add_development_dependency("rspec", "~> 2.6")
end
