require "rubygems"
require "httparty"
require "cachebar"
require "redis"
require 'redis-namespace'
require 'pry'
require 'dotenv'
require 'launchy'
require 'celluloid/pmap'
Dotenv.load

require_relative "ockapi/version"
require_relative "ockapi/base"
require_relative "ockapi/connection"
require_relative "ockapi/client"
require_relative "ockapi/representation"
require_relative "ockapi/representations/company"
require_relative "ockapi/representations/officer"
require_relative "ockapi/representations/datum"
require_relative "ockapi/representations/filing"
require_relative "ockapi/representer"

module Ockapi
end
