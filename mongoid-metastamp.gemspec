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
  s.summary     = %q{ Store and query for more information in your mongoid timestamps }
  s.description = %q{ Provides enhanced meta-timestamps for mongoid that allow querying by day, month, year, or by universal or local timezone. }

  s.rubyforge_project = "mongoid-metastamp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("mongoid", "~> 2.1")
  s.add_development_dependency("bson_ext", "~> 1.3")
  s.add_development_dependency("rake", "~> 0.9")
  s.add_development_dependency("rspec", "~> 2.6")
end
