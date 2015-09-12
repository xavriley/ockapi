require "rubygems"
require "rspec"
require "httparty"
require 'vcr'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require "ockapi/connection"
require "ockapi/client"
require "ockapi/representer"
require "ockapi/representation"
require "ockapi/representations/company"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('<%= ENV["OPENC_API_TOKEN"] %>') { ENV['OPENC_API_TOKEN'] }
  config.filter_sensitive_data('<%= ENV["COMPANIES_HOUSE_TOKEN"] %>') { ENV['COMPANIES_HOUSE_TOKEN'] }
end
