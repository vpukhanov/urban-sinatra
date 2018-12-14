class Article
  attr_reader :word, :definition, :example, :author

  def initialize(opts)
    @word = opts['word']
    @definition = convert_links(opts['definition'])
    @example = convert_links(opts['example'])
    @author = opts['author']
  end

  private

  def convert_links(text)
    text.gsub(/\[([^\]]*)\]/, '<a href="/\1">\1</a>')
  end
end
