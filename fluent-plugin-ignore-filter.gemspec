# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-ignore-filter"
  spec.version       = "0.0.1"
  spec.authors       = ["Yuri Umezaki"]
  spec.email         = ["bungoume@gmail.com"]
  spec.homepage      = "https://github.com/bungoume/fluent-plugin-ignore-filter"
  spec.summary       = "Fluentd filter plugin to ignore messages"
  spec.description   = spec.summary
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd", ">= 0.12"
  spec.add_development_dependency "rake"
end
