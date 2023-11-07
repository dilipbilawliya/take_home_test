
require 'page_analyzer'

describe PageAnalyzer do
  let(:sample_url) { 'https://example.com' }

  describe '#load' do
    it 'loads the HTML content of the page' do
      analyzer = PageAnalyzer.new(sample_url)
      expect { analyzer.load }.not_to raise_error
    end
  end

  describe '#fetch_page' do
    it 'fetches the HTML content of the page' do
      analyzer = PageAnalyzer.new(sample_url)
      expect { analyzer.fetch_page }.not_to raise_error
    end
  end

  describe '#link_count' do
    it 'returns the count of links on the page' do
      analyzer = PageAnalyzer.new(sample_url)
      analyzer.load
      expect(analyzer.link_count).to be >= 0
    end
  end

  describe '#image_count' do
    it 'returns the count of images on the page' do
      analyzer = PageAnalyzer.new(sample_url)
      analyzer.load
      expect(analyzer.image_count).to be >= 0
    end
  end

  describe '#last_accessed_time' do
    it 'returns the last accessed time as a Time object' do
      analyzer = PageAnalyzer.new(sample_url)
      expect(analyzer.last_accessed_time).to be_a(Time)
    end
  end

  describe '#access_info' do
    it 'returns a hash with link count, image count, and last accessed time' do
      analyzer = PageAnalyzer.new(sample_url)
      analyzer.load

      expect(analyzer.access_info).to be_a(Hash)
      expect(analyzer.access_info).to have_key(:links)
      expect(analyzer.access_info).to have_key(:images)
      expect(analyzer.access_info).to have_key(:last_accessed)
    end
  end
end
