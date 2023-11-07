require './lib/page_analyzer'
require './lib/asset'

  class PageScraper
  attr_reader :urls, :metadata

  def initialize(urls, metadata)
    @metadata = metadata
    @urls = urls
  end

  def process
    urls.each { |url| get_page(url) }
  end

  private

  def get_page(url)
    page = PageAnalyzer.new(url)
    asset = Assets.new(url, page.load).download_assets
    fetch_metadata(page, url) if metadata
  rescue StandardError => error
    display_fetch_error(url, error)
  end

  def fetch_metadata(page, url)
    num_link, num_image, last_fetch = page.access_info
    display_metadata(url, num_link, num_image, last_fetch)
  rescue StandardError => error
    display_fetch_error(url, error)
  end

  def display_metadata(url, num_links, num_images, last_fetch)
    puts "Website url: #{url}"
    puts "Number of Links found: #{num_links}"
    puts "Number of Images found: #{num_images}"
    puts "Last Fetch Date: #{last_fetch} \n\n"
  end

  def display_fetch_error(url, error)
    puts "Error fetching #{url}: #{error.message}"
  end
end

