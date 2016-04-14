# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certcenter/version'

Gem::Specification.new do |spec|
  spec.name          = "certcenter"
  spec.version       = Certcenter::VERSION
  spec.authors       = ["jfqd"]
  spec.email         = ["jfqd@blun.org"]

  spec.summary       = %q{Ruby API to order certificates from Certcenter AG.}
  spec.description   = %q{Ruby API to order (free domain validated) certificates from Certcenter AG.}
  spec.homepage      = "https://github.com/jfqd/certcenter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 0'
end
