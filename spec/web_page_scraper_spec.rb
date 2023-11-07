
require 'web_page_scraper'

describe WebPageScraper do
  let(:sample_urls) { ['https://example.com', 'https://test.com'] }
  let(:metadata_option) { true }

  describe '#get_page' do
    it 'fetches and processes a page with metadata' do
      scraper = WebPageScraper.new(sample_urls, metadata_option)
      expect { scraper.get_page('https://example.com') }.not_to raise_error
    end

    it 'handles fetch errors gracefully' do
      scraper = WebPageScraper.new(sample_urls, metadata_option)
      expect { scraper.get_page('invalid_url') }.to output(/Error fetching/).to_stdout
    end
  end

  describe '#fetch_page_metadata' do
    it 'fetches and displays metadata' do
      scraper = WebPageScraper.new(sample_urls, metadata_option)
      page_analyzer = instance_double(PageAnalyzer)
      allow(PageAnalyzer).to receive(:new).and_return(page_analyzer)
      allow(page_analyzer).to receive(:access_info).and_return(links: 10, images: 5, last_accessed: '2023-11-06')
      
      expect { scraper.fetch_page_metadata(page_analyzer, 'https://example.com') }.to output(/Website url: https:\/\/example\.com/).to_stdout
    end

    it 'handles fetch errors gracefully' do
      scraper = WebPageScraper.new(sample_urls, metadata_option)
      page_analyzer = instance_double(PageAnalyzer)
      allow(PageAnalyzer).to receive(:new).and_return(page_analyzer)
      allow(page_analyzer).to receive(:access_info).and_raise(StandardError, 'Metadata fetch error')

      expect { scraper.fetch_page_metadata(page_analyzer, 'https://example.com') }.to output(/Error fetching/).to_stdout
    end
  end

  describe '#process_urls' do
    it 'processes URLs with metadata option' do
      scraper = WebPageScraper.new(sample_urls, metadata_option)
      expect { scraper.process_urls }.not_to raise_error
    end

    it 'processes URLs without metadata option' do
      scraper = WebPageScraper.new(sample_urls, false)
      expect { scraper.process_urls }.not_to raise_error
    end
  end
end
