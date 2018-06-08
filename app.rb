# coding : utf-8

# ==============
# app.rb
# ==============
# arxiv printer

require "./lib/arXiv_downloader"
require "optparse"

module ArXiv
  class CLI
    def options_define(argv=ARGV)
      @opt = OptionParser.new
      @options = {
        url: "",
        distpath: "#{ENV["DIST_DIR"]}"
      }
      @opt.on("--url URL", "-u URL", "Target URL what arXiv page") {|v| @options[:url] = v}
      @opt.on("--dist DIST", "-d DIST", "Dropbox dir") {|v| @options[:dropbox_path] = v}
    end

    def run
      options_define
      begin
        @opt.parse!(ARGV)
      rescue OptionParser::InvalidOption => e
        puts e.message
      end
      raise "Invalid optional argument. --url is empty." if @options[:url].empty?

      scraper = ArXivDownloade.new(@options[:url])
      title = scraper.fetch_paper_title
      filename = title.gsub(/:-.,?~/, "").split(" ").join("_") + ".pdf"
      paper = scraper.download
      paper_size = paper.size
      File.open("#{@options[:distpath]}/#{filename}", "w") {|f| f.write(paper.read) }
      puts "Download arxiv paper"
      puts "   [URL]   : #{@options[:url]}"
      puts "   [Dist]  : #{@options[:distpath]}"
      puts "   [Title] : #{title}"
      puts "   [File name] : #{filename}"
      puts "   [File size] : #{(paper_size / 1024) / 1024} MByte"
    end
  end
end

if $0 == __FILE__
  include ArXiv
  CLI.new.run
end
