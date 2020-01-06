# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pmc_miller/version"

Gem::Specification.new do |spec|
  spec.name          = "pmc_miller"
  spec.version       = PmcMiller::VERSION
  spec.authors       = ["John Duarte"]
  spec.email         = ["john.duarte@puppet.com"]

  spec.summary       = "Process Puppet Metrics Collector data."
  spec.description   = "Library to process data created by Puppet Metrics Collector."
  spec.homepage      = "https://github.com/puppetlabs/pmc_miller"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.75"
end
