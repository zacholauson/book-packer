require 'rspec'
require_relative '../book_packer'

describe SimplePacker do
  before(:each) do
    @books = []
    parser = Parser.new("data/book1.html")
    book_data = parser.parse
    @books << Book.new(book_data)
  end

  it "should pack books" do
    packer = SimplePacker.new(@books)
    packer.pack_books[0].should be_an_instance_of(Box)
  end
end
