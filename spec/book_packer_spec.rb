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
  describe "creating a box" do
    before(:all) do
      @default_box = Box.new
      @custom_box  = Box.new(20)
    end

    it "should create a valid box with the default max weight" do
      expect(@default_box).to be_an_instance_of(Box)
      @default_box.max_weight.should eq(10)
    end

    it "should create a valid box with a custom weight" do
      expect(@custom_box).to be_an_instance_of(Box)
      @custom_box.max_weight.should eq(20)
    end

    it "should return the remaining weight the box can carry" do
      @default_box.weight_left.should eq(10)
      @custom_box.weight_left.should eq(20)
    end
  end

  describe "adding a book to a box" do
    before(:each) do
      book_data = { title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz", price: "26.48", weight: "1.1", isbn: "0321721330"}

      @book = Book.new(book_data)
      @box = Box.new
      @box.add_book(@book)
    end

    it "should add a book to a box" do
      @box.books.should eq([@book])
    end

    it "should return true if box has room for book" do
      @box.has_room?(@book).should be_true
    end

    it "should not add book if the box is over its max weight" do
      box = Box.new(1)
      expect { box.add_book(@book) }.to raise_exception(FullBoxException)
      box.books.should eq([])
    end

    it "should change current weight when adding a book" do
      @box.current_weight.should eq(1.1)
    end

    it "should return how much more weight the box can hold" do
      @box.weight_left.should eq(8.9)
    end
  end
end

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

describe Exporter do
  before(:all) do
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

