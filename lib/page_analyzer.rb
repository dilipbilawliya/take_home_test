require 'open-uri'
require 'nokogiri'

class PageAnalyzer
  attr_reader :doc, :url

  def initialize(url)
    @url = url
  end

  def load
    @doc = Nokogiri::HTML(URI.open(@url))
    get_assets(@url, @doc)
  end

  def access_info
    links = link_count
    images = image_count
    last_accessed = formatted_time(last_accessed_time)
    [links, images, last_accessed]
  end

  private

  def formatted_time(time)
    time.strftime('%a %b %d %Y %H:%M UTC')
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

  def get_assets(url, content)
    Assets.new(url, content).download_assets
  end
end