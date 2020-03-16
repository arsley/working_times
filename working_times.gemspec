lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'working_times/constants'

Gem::Specification.new do |spec|
  spec.name          = 'working_times'
  spec.version       = WorkingTimes::VERSION
  spec.authors       = ['Aoshi Fujioka']
  spec.email         = ['blue20will@gmail.com']

  spec.summary       = 'Store your working/worked time simply'
  spec.description   = 'Store your working/worked time simply. This gem gives simple CLI tool.'
  spec.homepage      = 'https://github.com/arsley/working_times'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'exe/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 5'
  spec.add_dependency 'thor', '~> 0.20.0'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
end
