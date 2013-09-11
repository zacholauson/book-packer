require 'nokogiri'
require 'json'

class FullBoxException < Exception; end

class Book
  attr_reader :title, :author, :price, :weight, :isbn

  def initialize(options)
    @title = options.fetch(:title)
    @author = options.fetch(:author)
    @price = options.fetch(:price)
    @weight = options.fetch(:weight).to_f
    @isbn = options.fetch(:isbn)
  end
end

class Box
  attr_reader :current_weight, :max_weight
  attr_accessor :books

  def initialize(max_weight = 10)
    @max_weight = max_weight
    @current_weight = 0
    @books = []
  end

  def add_book(book)
    if has_room?(book)
      @books.push(book)
      @current_weight += book.weight
    else
      raise FullBoxException
    end
  end

  def has_room?(book)
    book.weight < weight_left
  end

  def weight_left
    @max_weight - @current_weight
  end
end

class Parser
  attr_accessor :book_data

  def initialize(file)
    @page = Nokogiri::HTML(open(file))
  end

  def parse
    @title = parse_out_book_title
    @author = parse_out_author
    @price = parse_out_price
    @weight = parse_out_weight
    @isbn = parse_out_isbn
    @book_data = {title: @title, author: @author, price: @price, weight: @weight, isbn: @isbn}
  end

  def parse_out_book_title
    @page.css("div.buying h1").text.split("\n")[1]
  end

  def parse_out_author
    @page.css("div.buying span a").text.split("Details")[0]
  end

  def parse_out_price
    price = @page.css('form#handleBuy table .product #actualPriceValue .priceLarge').text
    if price == ""
      price = @page.css('form#handleBuy table td .rentPrice')[0].text
    end
    price
  end

  def parse_out_weight
    @page.css('div#detail-bullets table div.content ul').each do |i|
      if i.css("b").text.include?("Shipping Weight")
        return i.text.split('Shipping Weight')[1].split(' ')[1].to_f
      end
    end
  end

  def parse_out_isbn
    @page.css('div#detail-bullets table div.content ul').each do |i|
      if i.css("b").text.include?("ISBN-10")
        return i.text.split('ISBN-10:')[1].split(' ')[0]
      end
    end
  end
end

class SimplePacker
  attr_accessor :boxes, :books

  def initialize(books)
    @books = books
    @boxes = [Box.new]
  end

  def pack_books
    @books.each do |book|
      box = @boxes.last
      if !box.has_room?(book)
        @boxes.push(Box.new)
        box = @boxes.last
      end
      box.add_book(book)
    end

    @boxes.each do |box|
      p box
    end
  end
end

class Exporter
  def initialize(boxes)
    @boxes = boxes
    @exported_data = []
    @shipment = []
  end

  def export
    i = 0
    @boxes.each do |box|
      exported_box = {
        id: i += 1,
        totalWeight: box.current_weight,
        content: []
      }

      box.books.each do |book|
        book_hash = {
          title: book.title,
          author: book.author,
          price: book.price,
          weight: book.weight,
          isbn: book.isbn
        }
        exported_box[:content] << book_hash
      end
      return @shipment << exported_box
    end
  end

  def export_json_to_file
    if @shipment == []
      self.export
    end

    File.open("exported_shipment.json", "w") do |f|
      f.write(@shipment.to_json)
    end
  end
end

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

