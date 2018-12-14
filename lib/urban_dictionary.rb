require 'net/http'
require 'cgi'
require 'json'

require_relative 'article'

class UrbanDictionary
  SEARCH_URL = 'https://api.urbandictionary.com/v0/define?term='.freeze

  def define(term)
    uri = make_uri(term)
    response = Net::HTTP.get(uri)
    get_results(response)
  end

  private

  def make_uri(term)
    safe_term = CGI.escape(term)
    URI(UrbanDictionary::SEARCH_URL + safe_term)
  end

  def get_results(response)
    json = JSON.parse(response)
    json['list'].map { |article| Article.new(article) }
  end
end
