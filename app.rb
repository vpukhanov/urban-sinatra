# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'cgi'

require_relative 'lib/urban_dictionary'

configure do
  set :dictionary, UrbanDictionary.new
  set :top_words, ['shruggie', 'normie', 'smober', 'horosceptic', 'hand sauce',
                   'usie', 'selfiegenic', 'elationship', 'memers', 'kadult',
                   'frousin', 'bitheads', 'accidial']
end

before do
  @development = Sinatra::Base.development?
end

get '/' do
  @top_word = settings.top_words.sample
  erb :index
end

post '/' do
  redirect to('/' + CGI.escape(params['term']))
end

get '/:term' do
  @article = settings.dictionary.define(params['term'].strip)[0]
  redirect to('/404') unless @article

  erb :article
end
