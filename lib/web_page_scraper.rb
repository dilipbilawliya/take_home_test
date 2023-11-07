require 'nokogiri'
require './lib/page_analyzer'

class WebPageScraper
  def initialize(urls, metadata_option)
    @metadata_option = metadata_option
    @urls = urls
  end

  def get_page(url)
    page = PageAnalyzer.new(url)
    page.fetch_page
    save_page_assets(url)
    fetch_page_metadata(page, url) if @metadata_option
  rescue StandardError => error
    display_fetch_error(url, error)
  end

  def fetch_page_metadata(page, url)
    ans = page.access_info
    num_link = ans[:links]
    num_image = ans[:images]
    last_fetch = ans[:last_accessed]
    show_page_metadata(url, num_link, num_image, last_fetch)
  rescue StandardError => error
    display_fetch_error(url, error)
  end

  def process_urls
    if @metadata_option
      urls = @urls
    else
      urls = @urls.reject { |arg| arg == '--metadata' } 
    end
    urls.each { |url| get_page(url) }
  end

  def save_page_assets(url)
    parsed_page = Nokogiri::HTML(URI.open(url))
    host_uri = URI.parse(url)
    create_images_dir(host_uri.host)
    save_page_images(parsed_page, host_uri, url)
    save_html_page(parsed_page, host_uri.host)
  end

  private

  def show_page_metadata(url, num_links, num_images, last_fetch)
    puts "Website url: #{url}"
    puts "Number of Links found: #{num_links}"
    puts "Number of Images found: #{num_images}"
    puts "Last Fetch Date: #{last_fetch} \n\n"
  end

  def display_fetch_error(url, error)
    puts "Error fetching #{url}: #{error.message}"
  end

  def create_images_dir(host)
    images_dir = File.join(host, 'assets/images')
    FileUtils.mkdir_p(images_dir) unless Dir.exist?(images_dir)
  end

  def save_page_images(parsed_page, host_uri, url)
    parsed_page.css('img').each do |image|
      src = image['src']
      next if src.nil? || src.empty?

      image_url = URI.join(url, src).to_s
      image_path = File.join(host_uri.host, 'assets/images', File.basename(src))
      image_fetch_path = File.join('assets/images', File.basename(src))

      download_file(image_url, image_path)
      image['src'] = image_fetch_path
    end
  end

  def save_html_page(parsed_page, host)
    File.write(File.join(host, "#{host}.html"), parsed_page.to_html)
  end

  def download_file(url, path)
    URI.open(url) do |u|
      File.open(path, 'wb') { |f| f.write(u.read) }
    end
  end
end

