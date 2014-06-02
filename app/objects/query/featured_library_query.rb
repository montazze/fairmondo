# What used to be Exhibitions are now Libraries
class FeaturedLibraryQuery
  def initialize exhibition_name = nil
    set exhibition_name if exhibition_name
  end

  def set exhibition_name
    @exhibition_name = exhibition_name
    @library = Library.where(exhibition_name: exhibition_name).first
    @relation = LibraryElement.where(library_id: @library.id).includes(article: [:images,:seller]).joins(:article).where("articles.state = 'active'") if @library
    self
  end

  def find count = 2
    return { library: nil, exhibits: [] } unless @library

    exhibits = ordered_active_one_day_exhibited count
    exhibits.each do |exhibit|
      set_exhibition_date_of exhibit
    end
    exhibits = fill_exhibits_randomly( exhibits, count ) unless exhibits.length >= count

    { library: @library, exhibits: exhibits.map{ |exhibit| exhibit.article } }
  end

  private
    def ordered_active_one_day_exhibited limit
      @relation.where("library_elements.exhibition_date IS NULL OR library_elements.exhibition_date >= ?", DateTime.now - 1.day).order("library_elements.created_at ASC").limit limit
    end

    def set_exhibition_date_of library_element
      LibraryElement.find(library_element.id).update_attribute :exhibition_date, DateTime.now
    end

    # Conditional scope, used when one_day_exhibited doesn't return enough results
    # @return [Array] exhibits plus older ones to fill empty spaces
    def fill_exhibits_randomly exhibits, count
      max_offset = filler_query(exhibits).count - 1
      (count - exhibits.length).times do
        random_offset = rand 0..max_offset
        filler_library_element = filler_query(exhibits).offset(random_offset).first
        exhibits << filler_library_element if filler_library_element
        max_offset -= 1
      end
      exhibits
    end

    def filler_query exhibits
      @relation.where("library_elements.id NOT IN (?)", exhibits.map{|e| e.id } + [0] ).where("library_elements.exhibition_date IS NOT NULL AND library_elements.exhibition_date < ?", DateTime.now - 1.day)
    end
end