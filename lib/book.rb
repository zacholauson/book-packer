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
