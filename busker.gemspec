# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'busker/version'

Gem::Specification.new do |spec|
  spec.name          = "busker"
  spec.version       = Busker::VERSION
  spec.authors       = ["pachacamac"]
  spec.email         = ["pachacamac@users.noreply.github.com"]
  spec.summary       = %q{An extremely simple web framework}
  spec.description   = %q{An extremely simple web framework. It mimics Sinatra in some aspects while still trying to stay a true wanderer of the streets.}
  spec.homepage      = "https://github.com/pachacamac/busker"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
