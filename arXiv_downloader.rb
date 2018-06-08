# coding : utf-8

# =============
# Scrape arXiv
# =============
# scrape arxiv.com and download paper file with PDF

$:.unshift(File.join(File.dirname(__FILE__), "lib"))

require "open-uri"
require "nokogiri"
require "./lib/proxy_settings"

module ArXiv
  class PaperDownloader
    attr_accessor :url

    def initialize(url)
      @url = url
      @html = nil
      fetch_html
    end

    def fetch_paper_title
      title = @html.xpath("//*[@id=\"abs\"]/div[2]/h1/text()").text.strip!
    end

    def download
      paper_url = pdf_link
      paper = open(paper_url)
    end

    private
    def pdf_link
      url.gsub!("abs", "pdf")
    end

    def fetch_html
      html = Nokogiri::HTML(open(@url))
      @html = html
    end
  end
end
