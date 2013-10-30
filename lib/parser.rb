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
