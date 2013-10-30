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

class FullBoxException < Exception; end
