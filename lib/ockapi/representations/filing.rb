require 'open-uri'

module Ockapi
  class Filing < Representation
    def get_companies_house_doc(complex=false)
      cache_key = self.uid + complex.to_s
      if res = $redis.get(cache_key)
        if complex
          return Marshal.load(res)
        else
          return Marshal.load(res).content
        end
      end

      begin
        auth_options = { :basic_auth => {:username => ENV['COMPANIES_HOUSE_TOKEN']} }
        parent_company = self.parent
        filings_res = HTTParty.get("https://api.companieshouse.gov.uk/company/#{parent_company.company_number}/filing-history?items_per_page=100&category=annual-return,accounts", auth_options)
        case filings_res.code
        when 0, 200 # zero means cached
          if !filings_res.body.empty?
            filings_list = JSON.parse(filings_res.body)["items"]
          else
            return nil
          end
        else
          $stderr.puts "Couldn't retrieve fillings from Companies House API"
          require 'pry'; binding.pry
          $stderr.puts "Opening website instead"
          Launchy.open("https://beta.companieshouse.gov.uk/company/#{parent_company.company_number}/filing-history")

          return nil
        end

        ch_filing = filings_list.detect {|x|
          Date.parse((x["date"] || x["action_date"])) == Date.parse(self.date)
        }

        doc_meta_url = ch_filing.fetch("links", {}).fetch("document_metadata", nil)
        doc_meta = JSON.parse(HTTParty.get(doc_meta_url, auth_options).body)

        doc_mime_type = doc_meta["resources"].sort_by {|k,v|
          case k
          when /html/
            1
          when /pdf/
            2
          else
            3
          end
        }.first.first # yuck!

        doc_content_url = doc_meta.fetch("links", {}).fetch("document", nil)

        doc_s3_content_res = HTTParty.get(doc_content_url, auth_options.merge({:headers => {"Authorization" => "Basic", "Accept" => doc_mime_type}, :follow_redirects => false}))
        doc_s3_content_url = URI.parse(doc_s3_content_res.headers["location"])

        tmpfile = open(doc_s3_content_url)
        tmpfile_path = "/tmp/#{parent_company.company_number}-#{self.title.downcase.gsub(/\s/, '-')}-#{self.date}.pdf"
        open(tmpfile_path, 'wb') {|f| f << tmpfile.read }
        tmpfile = File.new(tmpfile_path)
        `pdfimages -png #{tmpfile.path} #{tmpfile_path}`

        image_paths = Dir.glob("#{tmpfile_path}*.png")
        content = image_paths.pmap(5) do |page|
          `tesseract #{page} stdout`
        end.join("\n")

        output = Filing.new(self.to_h.merge({
          content: content,
          image_paths: image_paths,
          pdf_path: tmpfile_path,
          ch_url: doc_s3_content_url
        }))

        $redis.set(cache_key,Marshal.dump(output))

        if complex
          output
        else
          output.content
        end
      end
    rescue
      require 'pry'; binding.pry
    end
  end
end
