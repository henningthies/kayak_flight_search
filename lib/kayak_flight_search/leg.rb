class KayakFlightSearch::Leg
 
  attr_reader :airline
  attr_reader :airline_display
  attr_reader :origin
  attr_reader :destination
  attr_reader :depart
  attr_reader :arrive
  attr_reader :stops
  attr_reader :duration_minutes
  attr_reader :cabin
  attr_reader :segments
  
  def initialize (leg)
    
    @airline = leg.xpath('airline').first.content
    @airline_display = leg.xpath('airline_display').first.content
    @origin = leg.xpath('orig').first.content
    @destination = leg.xpath('dest').first.content
    @depart = Time.parse(leg.xpath('depart').first.content)
    @arrive = Time.parse(leg.xpath('arrive').first.content)
    @stops = leg.xpath('stops').first.content.to_i
    @duration_minutes = leg.xpath('duration_minutes').first.content.to_i
    @cabin = leg.xpath('cabin').first.content
    
    @segments = []
    leg.xpath('segment').each do |segment|
      @segments << KayakFlightSearch::Segment.new(segment)
    end
    
  end
  
end