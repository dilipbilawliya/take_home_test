
require 'page_scraper'  

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
    it 'handles fetch errors gracefully' do
      scraper = PageScraper.new(sample_urls, metadata_option)
      page_analyzer = instance_double(PageAnalyzer)
      allow(PageAnalyzer).to receive(:new).and_return(page_analyzer)
      allow(page_analyzer).to receive(:load).and_raise(StandardError, 'Metadata fetch error')

      expect { scraper.send(:get_page, 'https://sample.com') }.to output(/Error fetching/).to_stdout
    end
  end
end
