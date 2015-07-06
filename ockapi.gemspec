# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ockapi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Xavier Riley"]
  gem.email         = ["info@xavierriley.co.uk"]
  gem.description   = %q{Ruby tools for working with the OpenCorporates API}
  gem.summary       = %q{A gem to make it easier to research companies and officers from around the world.}
  gem.homepage      = "https://github.com/xavriley/ockapi"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ockapi"
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "cachebar", ["~> 1.1"]
  gem.add_runtime_dependency "httparty", ["~> 0.8"]
  gem.add_runtime_dependency "pry", ["~> 0.10"]
  gem.add_runtime_dependency "redis", ["~> 3.2"]
  gem.add_runtime_dependency "redis-namespace", ["~> 1.5"]

  gem.add_development_dependency "rspec", ["~> 3.3"]

  gem.version       = Ockapi::VERSION
end
