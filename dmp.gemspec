
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dmp/version"

Gem::Specification.new do |spec|
  spec.name          = "dmp"
  spec.version       = Dmp::VERSION
  spec.authors       = ["Franccesco Orozco"]
  spec.email         = ["franccesco@codingdose.info"]

  spec.summary       = %q{Generate a secure passphrase.}
  spec.description   = %q{Generates a passphrase using EFF's long wordlist.}
  spec.homepage      = "https://github.com/franccesco/dmp"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.3"
end
