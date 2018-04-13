
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "taskmaster/version"

Gem::Specification.new do |spec|
  spec.name          = "taskmaster"
  spec.version       = Taskmaster::VERSION
  spec.authors       = ["uael"]
  spec.email         = ["lucas.abel@yandex.com"]

  spec.summary       = %q{Yet another job control daemon.}
  spec.homepage      = "https://github.com/uael/taskmaster.git"
  spec.license       = "Unlicense"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
