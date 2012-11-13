$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'lib/bitmask'
require 'lib/bitmask_attribute'

module AukanBitmask
  VERSION = '0.0.1'
end
