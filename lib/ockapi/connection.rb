require 'json'

module Ockapi
  class Connection
    include HTTParty

    DEFAULT_API_VERSION = "0.4"
    DEFAULT_BASE_URI    = "https://api.opencorporates.com"
    DEFAULT_QUERY       = {:api_token => ENV['OPENC_API_TOKEN']}

    base_uri DEFAULT_BASE_URI

    def initialize(options={})
      @api_version = options.fetch(:api_version, DEFAULT_API_VERSION)
      @connection  = self.class
    end

    def get(relative_path, query={})
      relative_path = add_api_version(relative_path)
      res = connection.get relative_path, query: DEFAULT_QUERY.merge(query).reject {|k,v| v.blank? }

      JSON.parse(res.body)
    end

    private

    attr_reader :connection

    def add_api_version(relative_path)
      "/#{api_version_path}#{relative_path}"
    end

    def api_version_path
      "v" + @api_version.to_s
    end
  end
end
