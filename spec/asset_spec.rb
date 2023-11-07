require 'fileutils'
require 'asset'

RSpec.describe Assets do
  let(:url) { 'https://example.com' }
  let(:host) { 'example.com' }
  let(:content) { Nokogiri::HTML::Document.parse('your_html_content_here') }

  before(:each) do
    @asset = Assets.new(url, content)
  end

  describe '#download_assets' do
    it 'creates an images directory' do
      allow(FileUtils).to receive(:mkdir_p).with(File.join(host, 'assets/images'))
      @asset.download_assets
    end

    it 'saves the HTML page' do
      allow(File).to receive(:write).with(File.join(host, "#{host}.html"), content.to_html)
      @asset.download_assets
    end

    it 'saves image assets and updates their src' do
      img = Nokogiri::HTML.fragment('<img src="image.jpg">').at('img')
      img['src'] = 'image.jpg' # Ensure the src is set
      allow(content).to receive(:css).with('img').and_return([img])

      image_url = URI.join(url, 'image.jpg').to_s
      image_path = File.join(host, 'assets/images', 'image.jpg')
      image_fetch_path = File.join('assets/images', 'image.jpg')

      expect(@asset).to receive(:download_file).with(image_url, image_path)

      @asset.download_assets

      expect(img['src']).to eq(image_fetch_path)
    end
  end
end
