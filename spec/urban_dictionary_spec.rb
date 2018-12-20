# frozen_string_literal: true

require 'urban_dictionary'
require 'article'
require 'net/http'
require 'cgi'

RSpec.describe UrbanDictionary do
  before do
    @dict = UrbanDictionary.new
  end

  context '#define' do
    it 'should form an uri with search term' do
      search_term = 'test'
      correct_url = UrbanDictionary::SEARCH_URL + search_term

      expect(Net::HTTP).to receive(:get).with(URI(correct_url))
      expect(@dict).to receive(:get_results)

      @dict.define(search_term)
    end

    it 'should escape search term' do
      search_term = '"my" test'
      search_term_escaped = '%22my%22+test'
      correct_url = UrbanDictionary::SEARCH_URL + search_term_escaped

      expect(CGI).to receive(:escape).with(search_term)
                                     .and_return(search_term_escaped)
      expect(Net::HTTP).to receive(:get).with(URI(correct_url))
      expect(@dict).to receive(:get_results)

      @dict.define(search_term)
    end

    it 'should return list of articles' do
      expect(Net::HTTP).to receive(:get)
        .and_return('{"list":[{"word":"","definition":"",
          "author":"","example":""}]}')

      @articles = @dict.define('anything')
      expect(@articles).to be_an(Array)
      expect(@articles[0]).to be_an(Article)
    end
  end
end
