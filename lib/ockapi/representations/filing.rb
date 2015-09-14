require 'open-uri'

module Ockapi
  class Filing < Representation
    def get_companies_house_doc(complex=false)
      auth_options = { :basic_auth => {:username => ENV['COMPANIES_HOUSE_TOKEN']} }
      parent_company = self.parent
      filings_res = HTTParty.get("https://api.companieshouse.gov.uk/company/#{parent_company.company_number}/filing-history", auth_options).body
      filings_list = JSON.parse(filings_res)["items"]

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
      `pdfimages -png #{tmpfile.path} /tmp/#{parent_company.company_number}`

      image_paths = Dir.glob("/tmp/#{parent_company.company_number}*.png")
      content = image_paths.map do |page|
        `tesseract #{page} stdout`
      end.join("\n")

      if complex
        {
          content: content,
          image_paths: image_paths,
          pdf_path: tmpfile.path
        }
      else
        content
      end
    end
  end
end
