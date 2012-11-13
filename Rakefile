require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/bitmask'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'aukan-bitmask' do
  self.developer 'Pablo Antonio Gonzalez Cervantes', 'pbglezc@gmail.com'
  self.rubyforge_name       = self.name # TODO this is default value
  self.version              = '0.0.3'
  self.summary              = 'Agnostic Bitmask and BitmaskAttribute.'
  self.description          = 'Agnostic Bitmask and BitmaskAttribute. This gem includes Bitmask for standalone usage, and BitmaskAttribute to decorate an existing attribute on any class.'
  self.homepage             = 'https://github.com/aukan/aukan-bitmask'
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
