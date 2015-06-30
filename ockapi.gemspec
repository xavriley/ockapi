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
  gem.version       = Ockapi::VERSION
end
