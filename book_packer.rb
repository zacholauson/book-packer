require 'nokogiri'
require 'json'

require_relative 'lib/book'
require_relative 'lib/box'
require_relative 'lib/exporter'
require_relative 'lib/parser'
require_relative 'lib/simple_packer'

books = []

Dir.glob("data/*.html") do |file|
  parser = Parser.new(file)
  book_data = parser.parse
  books << Book.new(book_data)
end

packer = SimplePacker.new(books)
packer.pack_books

exporter = Exporter.new(packer.boxes)
exporter.export
exporter.export_json_to_file
