require "rubygems"
require "httparty"
require "./connection"
require "./client"
require "./representation"
require "./representations/company"
require "./representer"

ROUTES = {
  companies: {
    method: "get",
    path: "/companies/search"
  }
}

connection = Connection.new
connection.query(jurisdiction_code: "gb", api_token: ENV['OPENC_API_TOKEN'])

client   = Client.new(connection: connection, routes: ROUTES)
# Doesn't deal with nested hash for source atm
result = client.companies["results"]["companies"].map {|x| x["company"].merge({"source" => nil}) }
puts Representation.new(result.first).inspect

require 'pry'; binding.pry
