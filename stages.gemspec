# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "stages"
  s.version = "2012.1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Acuff", "Justin Hill", "Matt Brown", "Kyle Prifogle"]
  s.date = "2012-01-13"
  s.description = "pipeline builder"
  s.email = "support@igodigital.com"
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README",
    "Rakefile",
    "VERSION",
    "stages.gemspec",
    "test/test_pipeline.rb",
    "test/test_stages.rb"
  ]
  s.homepage = "https://github.com/iGoDigital-LLC/stages"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "pipeline builder"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, ["= 0.9.2"])
    else
      s.add_dependency(%q<rake>, ["= 0.9.2"])
    end
  else
    s.add_dependency(%q<rake>, ["= 0.9.2"])
  end
end

