require 'rspec'
require_relative '../book_packer'

describe Book do
  before(:all) do
    book_data = { title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz", price: "$26.48", weight: "1.1", isbn: "0321721330"}
    @book = Book.new(book_data)
  end
  it "should assign the title" do
    @book.title.should == "Practical Object-Oriented Design in Ruby"
  end

  it "should assign the author" do
    @book.author.should == "Sandi Metz"
  end

  it "should assign the price" do
    @book.price.should == "$26.48"
  end

  it "should assign the weight" do
    @book.weight.should == 1.1
  end
  it "should assign the isbn" do
    @book.isbn.should == "0321721330"
  end
end

describe Box do
end
