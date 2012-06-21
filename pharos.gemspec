# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pharos"
  s.version     = "0.0.7"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Saloon"]
  s.email       = ["pharos@saloon.io"]
  s.homepage    = "http://github.com/pharos/pharos.rb"
  s.summary     = %q{Phaor API client}
  s.description = %q{Wrapper for Pharos REST API}

  s.add_dependency "multi_json", "~> 1.0"
  s.add_dependency "httparty"

  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "webmock"
  s.add_development_dependency "em-http-request", "~> 1.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rack"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
