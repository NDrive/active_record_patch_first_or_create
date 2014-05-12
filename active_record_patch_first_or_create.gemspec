# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_patch_first_or_create/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record_patch_first_or_create"
  spec.version       = ActiveRecordPatchFirstOrCreate::VERSION
  spec.authors       = ["NDrive DevOps Team"]
  spec.email         = ["devops@ndrive.com"]
  spec.summary       = %q{ActiveRecord patch first_or_create atomic version}
  spec.description   = %q{This patch provides first_or_create method to be atomic, once the default one isn't!!!}
  spec.homepage      = "http://www.ndrive.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
