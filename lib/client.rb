require 'uri'

class Client
  DEFAULT_ROUTES = {
    companies: {
      method: "get",
      path: "/companies/search"
    },
    company: {
      method: "get",
      path: "/companies"
    },
    officers: {
      method: "get",
      path: "/officers/search"
    },
    officer: {
      method: "get",
      path: "/officers"
    }
  }

  def initialize(options={})
    @connection = options.fetch(:connection)
    @routes     = options.fetch(:routes, DEFAULT_ROUTES)
  end

  def method_missing(method, *request_arguments)

    # retrieve the route map
    route_map = routes.fetch(method)

    # make request via the connection
    response_from_route(route_map, request_arguments)
  end

  private

  attr_reader :connection, :routes

  def response_from_route(route_map, request_arguments)

    # gather the routes required parameters
    http_method   = route_map.fetch(:method)
    relative_path = route_map.fetch(:path)

    path_args_orig     = request_arguments.find {|x| x[:path_args] }
    path_args     = Array((path_args_orig || {})[:path_args]).join("/")

    # call the connection for records
    # hacky hack hack hack for getting a relative file path
    # OC API doesn't like trailing slashes
    connection.send(http_method, File.join(relative_path, path_args).gsub(/\/\Z/, ''), *(request_arguments - [path_args_orig]))
  end
end
