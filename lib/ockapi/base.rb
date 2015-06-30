module Ockapi
  class Base
    REDIS_CONFIG = {
      'host' => "localhost",
      'port' => "6379",
      'db' => 15
    }

    def initialize
      redis = Redis.new(:host => REDIS_CONFIG['host'], :port => REDIS_CONFIG['port'],
                        :thread_safe => true, :db => REDIS_CONFIG['db'])
      $redis = Redis::Namespace.new(REDIS_CONFIG['namespace'], :redis => redis)

      HTTParty::HTTPCache.logger = Logger.new(STDOUT)
      HTTParty::HTTPCache.redis = $redis
      HTTParty::HTTPCache.perform_caching = true
      CacheBar.register_api_to_cache('api.opencorporates.com', {:key_name => "opencorporates", :expire_in => 7200})
    end

    def run
      binding.pry
    end

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

    # Implement these later?
    # Placeholder
    # CorporateGrouping
    # Filing
    # Statement
  end
end
