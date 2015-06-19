require "rubygems"
require "httparty"
require "cachebar"
require "redis"
require 'redis-namespace'

require "./connection"
require "./client"
require "./representation"
require "./representations/company"
require "./representations/officer"
require "./representations/datum"
require "./representer"

REDIS_CONFIG = {
  'host' => "localhost",
  'port' => "6379",
  'db' => 15
}

redis = Redis.new(:host => REDIS_CONFIG['host'], :port => REDIS_CONFIG['port'],
           :thread_safe => true, :db => REDIS_CONFIG['db'])
$redis = Redis::Namespace.new(REDIS_CONFIG['namespace'], :redis => redis)

HTTParty::HTTPCache.logger = Logger.new(STDOUT)
HTTParty::HTTPCache.redis = $redis
HTTParty::HTTPCache.perform_caching = true
CacheBar.register_api_to_cache('api.opencorporates.com', {:key_name => "opencorporates", :expire_in => 7200})

# connection = Connection.new
# connection.query(registered_address:"Ewhurst GU6", current_status: "Active", jurisdiction_code: "gb", api_token: ENV['OPENC_API_TOKEN'])

# client   = Client.new(connection: connection)
# Doesn't deal with nested hash for source atm
# result = client.companies["results"]["companies"].map {|x| x["company"] }
# Representation.new({"companys" => result}).companys

# Return single company - reconcile
# OpenCorporatesAPI::Company.find
# OpenCorporatesAPI::Company.find_by

# Return collections
# OpenCorporatesAPI::Company.search(opts = {q: "string", limit: 30, load_full_details: true})

require 'pry'; binding.pry

# Implement these later?
# Officer
# Placeholder
# CorporateGrouping
# Filing
# Statement
# Data
