require 'open-uri'
require 'nokogiri'

class PageAnalyzer

  attr_reader :url, :content

  def initialize(url)
    @url = url
  end

  def load
    @doc = Nokogiri::HTML(URI.open(url))
  end
  
  def fetch_page
    @content = download_page
  end

  def link_count
    load unless @doc
    @doc.css('a').count
  end

  def image_count
    load unless @doc  
    @doc.css('img').count
  end

  def last_accessed_time
    accessed_time ||= Time.now.utc
  end

  def access_info
    {
      links: link_count,
      images: image_count,
      last_accessed: formatted_time(last_accessed_time)
    }
  end

  private

  def download_page
    URI.open(url).read
  end

  def formatted_time(time)
    time.strftime('%a %b %d %Y %H:%M UTC')
  end
end