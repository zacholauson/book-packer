require 'rspec'
require_relative '../book_packer'

describe Exporter do
  before(:each) do
    @books = []
    parser = Parser.new("data/book1.html")
    book_data = parser.parse
    @books << Book.new(book_data)
    packer = SimplePacker.new(@books)
    packer.pack_books
    @exporter = Exporter.new(packer.boxes)
    @first_book_exported = {id: 1, totalWeight: 1.2, content: [{title: "Zealot: The Life and Times of Jesus of Nazareth [Hardcover]", author: "Reza Aslan", price: "$16.89", weight: 1.2, isbn: "140006922X"}]}
  end

  it "should parse out json" do
    @exporter.export.should == [@first_book_exported]
  end

  it "should export to exported_shipment.json" do
    @exporter.export_json_to_file
    File.exist?("exported_shipment.json").should be_true
  end
end
