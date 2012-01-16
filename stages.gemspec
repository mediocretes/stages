# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "stages"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Justice Eight"]
  s.date = "2012-01-16"
  s.description = "pipeline builder"
  s.email = "support@igodigital.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".autotest",
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "examples/sing.rb",
    "examples/sing_custom_stages.rb",
    "examples/sing_subpipes.rb",
    "lib/stage_base.rb",
    "lib/stages.rb",
    "lib/stages/count.rb",
    "lib/stages/each.rb",
    "lib/stages/emit.rb",
    "lib/stages/map.rb",
    "lib/stages/restrict.rb",
    "lib/stages/resume.rb",
    "lib/stages/resume_count.rb",
    "lib/stages/select.rb",
    "lib/stages/wrap.rb",
    "stages.gemspec",
    "test/helper.rb",
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

