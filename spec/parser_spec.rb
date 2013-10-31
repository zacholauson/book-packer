require 'rspec'
require_relative '../book_packer'

describe Parser do
  before(:all) do
    @parsed = Parser.new("data/book1.html")
    @parsed_data = @parsed.parse
  end

  it "should parse out the title of the book" do
    @parsed_data[:title].should == "Zealot: The Life and Times of Jesus of Nazareth [Hardcover]"
  end

  it "should parse out the author of the book" do
    @parsed_data[:author].should == "Reza Aslan"
  end

  it "should parse out the price of the book" do
    @parsed_data[:price].should == "$16.89"
  end

  it "should parse out the weight of the book" do
    @parsed_data[:weight].should == 1.2
  end

  it "should parse out the isbn of the book" do
    @parsed_data[:isbn].should == "140006922X"
  end
end
