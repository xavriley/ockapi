require "rubygems"
require "rspec"
require "httparty"

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require "ockapi/connection"
require "ockapi/client"
require "ockapi/representer"
require "ockapi/representation"
require "ockapi/representations/company"
