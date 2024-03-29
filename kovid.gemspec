# frozen_string_literal: true

require_relative 'lib/kovid/version'

Gem::Specification.new do |spec|
  spec.name          = 'kovid'
  spec.version       = Kovid::VERSION
  spec.authors       = ['Emmanuel Hayford']
  spec.email         = ['siawmensah@gmail.com']

  summary = 'A CLI to fetch and compare the 2019 ' \
            'coronavirus pandemic statistics.'
  spec.summary       = summary
  spec.description   = summary
  spec.homepage      = 'https://github.com/siaw23/kovid'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/siaw23/kovid'
  spec.metadata['changelog_uri'] = 'https://github.com/siaw23/kovid'

  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'terminal-table', '~> 1.8'
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'typhoeus', '~> 1.3'
  spec.add_development_dependency 'simplecov', '~>  0.18'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  #   that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
