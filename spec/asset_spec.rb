# spec/assets_spec.rb

require 'asset'  # Update the require path as needed

describe Assets do
  let(:sample_url) { 'https://sample.com' }

  describe '#download_assets' do
    it 'downloads and saves assets and HTML page for a given URL' do
      assets = Assets.new(sample_url)
      expect { assets.download_assets }.not_to raise_error
    end
  end

  describe 'private methods' do
    it 'creates an images directory' do
      assets = Assets.new(sample_url)
      expect { assets.send(:create_images_dir, 'sample.com') }.not_to raise_error
    end

    it 'saves an HTML page' do
      assets = Assets.new(sample_url)
      parsed_page = Nokogiri::HTML(URI.open(sample_url))
      expect { assets.send(:save_html_page, parsed_page, 'sample.com') }.not_to raise_error
    end

    it 'saves page images' do
      assets = Assets.new(sample_url)
      parsed_page = Nokogiri::HTML(URI.open(sample_url))
      host_uri = URI.parse(sample_url)
      expect { assets.send(:save_page_images, parsed_page, host_uri, sample_url) }.not_to raise_error
    end
  end
end
