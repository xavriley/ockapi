class Officer < Representation
  def self.search(opts = {})
    Search.new(opts).all.map(&:company).flatten.map(&:full!).uniq
  end

  def related_companies
    self.class.search(:name => name, :date_of_birth => date_of_birth)
  end

  def full!
    return self if not source.nil?

    # else returns a new object
    client   = Client.new(connection: Connection.new)
    Officer.new(client.officer(path_args: [id])["results"]["officer"])
  end

  class Search
    class SearchError < StandardError; end

    # [9] pry(main)> client.companies.keys
    # => ["api_version", "results"]
    # [10] pry(main)> client.companies["results"].keys
    # => ["companies", "page", "per_page", "total_pages", "total_count"]

    def initialize(query = {}, options = {})
      @query               = query
      @query[:api_token]   ||= ENV['OPENC_API_TOKEN']
      @query[:per_page]    ||= 100

      # Limit isn't part of the OC API
      @limit       = options.fetch(:limit, 100)

      @connection  = Connection.new
    end

    def page(page_no = 1)
      @connection.query(@query.merge(page: page_no))
      client   = Client.new(connection: @connection)
      res = client.officers
      if res["error"]
        raise SearchError.new(res["error"]["message"])
      else
        if page_no == 1
          $stderr.puts "#{@query.inspect}"
          $stderr.puts "Found #{res["results"]["total_count"]} officers"
        end
        res
      end
    end

    def find
      first_page = page
      Representation.new("officers" => first_page["results"]["officers"].map {|x| x["officer"] }).officers.first
    end

    def all
      if @limit.nil?
        raise SearchError.new("all must be used with a limit argument")
      end

      @limit = @limit.to_i
      @per_page = @query[:per_page].to_i

      first_page      = page
      no_pages        = first_page["results"]["total_pages"]

      if no_pages.to_i > 1
        if @limit > @per_page
          user_page_limit = @limit/@per_page
        else
          user_page_limit = @limit
        end

        results = [first_page["results"]["officers"]]
        (2..[no_pages, user_page_limit].min).each do |i|
          results << page(i)["results"]["officers"]
        end
      else
        results = first_page
      end

      Representation.new({"officers" => (results.flatten[0..@limit].map {|x| x["officer"] }) }).officers
    end
  end
end
