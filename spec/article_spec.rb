# frozen_string_literal: true

require 'article'

RSpec.describe Article do
  before do
    @param_hash = {
      'word' => 'Test',
      'definition' => '[My] test [case] in [a nutshell]',
      'example' => 'This is [usage] example with [a space]',
      'author' => 'QA person'
    }
    @article = Article.new(@param_hash)
  end

  context '::new' do
    it 'should read parameters from the hash' do
      expect(@article.word).to eq('Test')
      expect(@article.definition).to include('My', 'test', 'case')
      expect(@article.example).to include('This', 'is', 'usage', 'example')
      expect(@article.author).to eq('QA person')
    end

    it 'should convert definition words in brackets to links' do
      expect(@article.definition).to include(
        '<a href="/My">My</a>',
        '<a href="/case">case</a>',
        '<a href="/a nutshell">a nutshell</a>'
      )
      expect(@article.definition).to_not include(
        '<a href="/test">test</a>'
      )
    end

    it 'should convert example words in brackets to links' do
      expect(@article.example).to include(
        '<a href="/usage">usage</a>',
        '<a href="/a space">a space</a>'
      )
      expect(@article.example).to_not include('<a href="/This">This</a>')
    end
  end
end
