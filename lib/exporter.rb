class Exporter
  def initialize(boxes)
    @boxes = boxes
    @exported_data = []
    @shipment = []
  end

  def export
    i = 0
    @boxes.each do |box|
      exported_box = {
        id: i += 1,
        totalWeight: box.current_weight,
        content: []
      }

      box.books.each do |book|
        book_hash = {
          title: book.title,
          author: book.author,
          price: book.price,
          weight: book.weight,
          isbn: book.isbn
        }
        exported_box[:content] << book_hash
      end
      return @shipment << exported_box
    end
  end

  def export_json_to_file
    if @shipment == []
      self.export
    end

    File.open("exported_shipment.json", "w") do |f|
      f.write(@shipment.to_json)
    end
  end
end
