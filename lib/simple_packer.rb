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
       box
    end
  end
end

