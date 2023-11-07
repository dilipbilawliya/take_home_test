
require 'page_analyzer'  
require 'asset'

describe PageAnalyzer do
  let(:sample_url) { 'https://sample.com' }
  
  describe '#load' do
    it 'loads the HTML content of the page' do
      analyzer = PageAnalyzer.new(sample_url)
      expect { analyzer.load }.not_to raise_error
    end
  end

  describe '#access_info' do
    it 'returns an array with link count, image count, and last accessed time' do
      analyzer = PageAnalyzer.new(sample_url)
      expect(analyzer.access_info).to be_an_instance_of(Array)
      expect(analyzer.access_info.size).to eq(3)
    end
  end

  describe 'private methods' do
    it 'formats time correctly' do
      analyzer = PageAnalyzer.new(sample_url)
      time = Time.utc(2023, 11, 8, 12, 0)
      expect(analyzer.send(:formatted_time, time)).to eq('Wed Nov 08 2023 12:00 UTC')
    end

    it 'returns the count of links on the page' do
      analyzer = PageAnalyzer.new(sample_url)
      expect(analyzer.send(:link_count)).to be >= 0
    end

    it 'returns the count of images on the page' do
      analyzer = PageAnalyzer.new(sample_url)
      expect(analyzer.send(:image_count)).to be >= 0
    end

    it 'returns the last accessed time as a Time object' do
      analyzer = PageAnalyzer.new(sample_url)
      expect(analyzer.send(:last_accessed_time)).to be_a(Time)
    end
  end
end
