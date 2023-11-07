require 'nokogiri'
require 'open-uri'

class Assets

  attr_reader :url, :content

  def initialize(url, content)
    @url = url
    @content = content
  end

  def download_assets
    parsed_page = content
    host_uri = URI.parse(url)
    create_images_dir(host_uri.host)
    save_page_images(parsed_page, host_uri, url)
    save_html_page(parsed_page, host_uri.host)
  end

  private
  
  def create_images_dir(host)
    images_dir = File.join(host, 'assets/images')
    FileUtils.mkdir_p(images_dir) unless Dir.exist?(images_dir)
  end

  def save_html_page(parsed_page, host)
    File.write(File.join(host, "#{host}.html"), parsed_page.to_html)
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

  def download_file(url, path)
    URI.open(url) do |u|
      File.open(path, 'wb') { |f| f.write(u.read) }
    end
  end
end