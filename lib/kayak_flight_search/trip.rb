class KayakFlightSearch::Trip
 
  attr_reader :id
  attr_reader :price
  attr_reader :currency
  attr_reader :url
  attr_reader :legs
  
  def initialize (trip)
    
    @id = trip['id']
    @price = trip.xpath('price').first.text.to_i
    @currency = trip.xpath('price').first['currency']
    @url = "http://www.kayak.com#{trip.xpath('price').first['url']}"
    
    @legs = []
    trip.xpath('legs/leg').each do |leg|
      @legs << KayakFlightSearch::Leg.new(leg)
    end
    
  end
  
end