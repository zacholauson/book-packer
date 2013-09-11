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
end
