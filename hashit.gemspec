# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hashit'

Gem::Specification.new do |spec|
  spec.name          = "hashit"
  spec.version       = Hashit::VERSION
  spec.authors       = ["Nitzan Blankleder","Gabriel Manricks"]
  spec.email         = ["nitzanblanko@gmail.com"]
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "openssl"
  spec.add_runtime_dependency "date"
end
