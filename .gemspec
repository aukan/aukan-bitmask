require 'rubygems'
require 'rake'

spec = Gem::Specification.new do |s|
  s.author = 'Pablo Gonzalez'
  s.email = 'pbglezc@gmail.com'
  s.name = 'aukan-bitmask'
  s.version = '0.0.4'
  s.summary = 'Agnostic Bitmask and BitmaskAttribute.'
  s.description = 'Agnostic Bitmask and BitmaskAttribute. This gem includes Bitmask for standalone usage, and BitmaskAttribute to decorate an existing attribute on any class.'
  s.homepage = 'https://github.com/aukan/aukan-bitmask'
  s.rubyforge_project = 'aukan-bitmask'

  s.files = FileList[ File.read('Manifest.txt').split(/\n/) ].to_a
end
