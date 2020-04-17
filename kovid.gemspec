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
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/siaw23/kovid'
  spec.metadata['changelog_uri'] = 'https://github.com/siaw23/kovid'

  spec.add_dependency 'carmen', '~> 1.1.3'
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

  spec.post_install_message = "
    ============================================================================
      COVID-19 has devasted the world. While we're fighting
      with the novel coronavirus, I think stats on the issue should be
      accessible.

      There isn't much we can do now besides following procedures and hoping
      for the best.

      Stay safe!
      Emmanuel Hayford.
      https://emmanuelhayford.com

      PS: I'm in search of a Rails/Ruby job.

      You can hire me (siawmensah@gmail.com).
    ============================================================================
    "
end
