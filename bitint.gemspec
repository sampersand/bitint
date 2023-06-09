# frozen_string_literal: true

require_relative 'lib/bitint/version'

Gem::Specification.new do |spec|
  spec.name = 'bitint'
  spec.version = BitInt::VERSION
  spec.authors = ['Sam Westerman']
  spec.email = ['mail@sampersand.me']

  spec.summary = "A 2's-complement integer of arbitrary length"
  # spec.description = 'todo: Write a longer description or delete this line.'
  spec.homepage = 'https://github.com/sampersand/bitint'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata["source_code_uri"] = 'https://github.com/sampersand/bitint'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  # spec.bindir = 'exe'
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  # spec.require_paths = ['lib']
end
