lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seventeen_mon/version'

Gem::Specification.new do |spec|
  spec.name          = "seventeen_mon"
  spec.version       = SeventeenMon::VERSION
  spec.authors       = ["blindingdark"]
  spec.email         = ["blindingdark@outlook.com"]
  spec.summary       = "Simply find location by IP."
  spec.description   = "Simply find location by IP."
  spec.homepage      = "https://github.com/BlindingDark/SeventeenMon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1.1"
  spec.add_development_dependency "rspec"
end
