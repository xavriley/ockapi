class Company < Representation
  def industry_code_descriptions
    if industry_codes
      industry_codes.map {|code|
        code.description
      }
    end
  end

  def full!
    return self if not officers.nil?

    # else returns a new object
    client   = Client.new(connection: Connection.new)
    Company.new(client.company(path_args: [jurisdiction_code, company_number])["results"]["company"])
  end

  def self.search(opts = {})
    Search.new(opts).page(1).first
  end

  def self.find(jurisdiction_code, company_number)
    # Call full! by default on single companies
    Search.new({company_number: company_number, jurisdiction_code: jurisdiction_code}).find.full!
  end

  # Implement `uniq` on Company
  # taken from http://blog.nathanielbibler.com/post/73525836/using-the-ruby-array-uniq-with-custom-classes

  # Internally, Ruby converts your array
  # objects each into a hash (identifier,
  # not object), using #hash.  By default
  # this is #object_id.hash, which is no
  # longer appropriate.  The purpose is
  # to recognize which objects have the
  # same hash and which do not, thus they
  # are unique.  So, override.
  def hash
    opencorporates_url.hash
  end

  # Simply delegate to == in this example.
  def eql?(comparee)
    self == comparee
  end

  # Objects are equal if they have the same
  # unique custom identifier.
  def ==(comparee)
    self.opencorporates_url == comparee.opencorporates_url
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
      res = client.companies
      if res["error"]
        raise SearchError.new(res["error"]["message"])
      else
        if page_no == 1
          $stderr.puts "#{@query.inspect}"
          $stderr.puts "Found #{res["results"]["total_count"]} companies"
        end
        res
      end
    end

    def find
      first_page = page
      Representation.new("companys" => first_page["results"]["companies"].map {|x| x["company"] }).companys.first
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

        results = [first_page["results"]["companies"]]
        (2..[no_pages, user_page_limit].min).each do |i|
          results << page(i)["results"]["companies"]
        end
      else
        results = first_page
      end

      Representation.new({"companys" => (results.flatten[0..@limit].map {|x| x["company"] }) }).companys
    end
  end
end
