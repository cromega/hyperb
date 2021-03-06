# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hyperb/version'

Gem::Specification.new do |spec|
  spec.name          = 'hyperb'
  spec.version       = Hyperb::VERSION
  spec.authors       = ['drish']
  spec.email         = ['carlosderich@gmail.com']

  spec.description   = %q{The Hyper.sh Ruby Gem}
  spec.homepage      = 'https://github.com/drish/hyperb'
  spec.summary       = spec.description
  spec.license       = 'MIT'

  spec.require_paths = ['lib']
  spec.files         = `git ls-files`.split("\n")

  spec.add_dependency 'http', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10.4'
  spec.add_development_dependency 'pry-byebug'

  spec.required_ruby_version = '>= 2.2'
end
