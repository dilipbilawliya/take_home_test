# spec/page_scraper_spec.rb

require 'page_scraper'  # Update the require path as needed

describe PageScraper do
  let(:sample_urls) { ['https://sample.com'] }
  let(:metadata_option) { true }

  describe '#process' do
    it 'processes URLs and fetches pages' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      expect { scraper.process }.not_to raise_error
    end
  end

  describe '#get_page' do
    it 'fetches a page and its assets' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      expect { scraper.send(:get_page, 'https://sample.com') }.not_to raise_error
    end

    it 'handles fetch errors gracefully' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      expect { scraper.send(:get_page, 'invalid_url') }.to output(/Error fetching/).to_stdout
    end
  end

  describe '#fetch_metadata' do
    it 'fetches and displays metadata' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      page_analyzer = instance_double(PageAnalyzer)
      allow(PageAnalyzer).to receive(:new).and_return(page_analyzer)
      allow(page_analyzer).to receive(:access_info).and_return([10, 5, Time.now.utc])

      expect { scraper.send(:fetch_metadata, page_analyzer, 'https://sample.com') }.to output(/Website url: https:\/\/sample\.com/).to_stdout
    end

    it 'handles fetch errors gracefully' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      page_analyzer = instance_double(PageAnalyzer)
      allow(PageAnalyzer).to receive(:new).and_return(page_analyzer)
      allow(page_analyzer).to receive(:access_info).and_raise(StandardError, 'Metadata fetch error')

      expect { scraper.send(:fetch_metadata, page_analyzer, 'https://sample.com') }.to output(/Error fetching/).to_stdout
    end
  end
end
