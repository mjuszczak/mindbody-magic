# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mindbody_magic/version'

Gem::Specification.new do |spec|
  spec.name          = "mindbody_magic"
  spec.version       = MindbodyMagic::VERSION
  spec.authors       = ["Matt Juszczak"]
  spec.email         = ["matt@atopia.net"]

  spec.summary       = "MINDBODY Helper Gem"
  spec.homepage      = ""
  spec.license       = "Proprietary"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.12'

  spec.add_runtime_dependency 'pry', '~> 0.10.4'
  spec.add_runtime_dependency 'sequel', '~> 4.40.0'
  spec.add_runtime_dependency 'activesupport', '~> 5.0.0'
  spec.add_runtime_dependency 'mindbody-api'
  spec.add_runtime_dependency 'trollop', '~> 2.1.2'
  spec.add_runtime_dependency 'ice_nine', '~> 0.11.2'
  spec.add_runtime_dependency 'pg', '~> 0.19.0'
end
