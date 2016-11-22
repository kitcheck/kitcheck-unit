# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unit/version'

Gem::Specification.new do |spec|
  spec.name          = "kitcheck-unit"
  spec.version       = Unit::VERSION
  spec.authors       = ["Christian Doyle"]
  spec.email         = ["christian@kitcheck.com"]
  spec.description   = %q{Same unit handling for Ruby}
  spec.summary       = %q{Same unit handling for Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://gems.kitcheck.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda", "~> 3.5.0"
  spec.add_development_dependency 'pry', '~> 0.10.0'
  spec.add_development_dependency 'pry-byebug', '2.0.0'
  spec.add_development_dependency 'racc'
  spec.add_development_dependency 'rexical'
end
