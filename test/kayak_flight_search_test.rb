ENV['KAYAK_API_KEY'] ||= 'bAfqq0x4X6HD4$GFD8QMkQ'
require 'rubygems'
require 'active_support'
require 'test/unit'
require 'kayak_flight_search'

class KayakFlightSearchTest < Test::Unit::TestCase
  
  def setup
    @doc = Nokogiri::XML.parse(File.read(File.expand_path(File.dirname(__FILE__) + '../../test/test.xml')))
    @kayak_flight_search = KayakFlightSearch::Client.new
    @result = @kayak_flight_search.lookup(:depart_airport => "HAM", :arrival_airport => "LCY")
  end
  
  def test_should_get_session_id
    assert_not_nil @kayak_flight_search.session_id
  end
  
  def test_should_get_search_id
    assert_equal @result.search_id, @kayak_flight_search.search_id
  end
  
  def test_should_return_response_object
    assert_instance_of KayakFlightSearch::Result, @result
    assert_instance_of KayakFlightSearch::Response, @result.get_results   
  end
  
  def test_should_parse_xml
    response = KayakFlightSearch::Response.new(@doc)
    
    # check response :count :more_pending :trips
    assert_instance_of KayakFlightSearch::Response, response
    assert_kind_of Numeric, response.count
    assert_equal 9, response.count
    assert_equal "false", response.more_pending
    assert_instance_of Array, response.trips
    
    # check response.trips :id :price :currency :url :legs
    trip = response.trips.first
    assert_instance_of KayakFlightSearch::Trip, trip    
    assert_equal "163dc33038e0495a630b5f19b76cb453", trip.id
    assert_kind_of Numeric, trip.price
    assert_equal 259, trip.price
    assert_equal "USD", trip.currency
    assert_equal "http://www.kayak.com/book/flight?code=a13d9a33d2.Spz_Dd.0.F.ORBITZAIR.25919.163dc33038e0495a630b5f19b76cb453&_sid_=17-Jmuz2rajdyYtbpnpmgKz", trip.url
    assert_instance_of Array, trip.legs
    
    #check response.trips.legs :airline :airline_display :origin :destination :depart_date :depart_time :arrive_date :arrive_time :stops :duration_minutes :cabin :segments
    leg = response.trips.first.legs.first
    assert_instance_of KayakFlightSearch::Leg, leg 
    assert_equal "AB", leg.airline
    assert_equal "Air Berlin", leg.airline_display
    assert_equal "HAM", leg.origin
    assert_equal "ZRH", leg.destination
    assert_instance_of Time, leg.depart
    assert_instance_of Time, leg.arrive
    assert_kind_of Numeric, leg.stops
    assert_equal 1, leg.stops
    assert_kind_of Numeric, leg.duration_minutes
    assert_equal 195, leg.duration_minutes    
    assert_equal "Economy", leg.cabin
    assert_instance_of Array, leg.segments
    
    #check response.trips.legs.segments :airline :flight :duration :equip :miles :origin :destination :depart_date :depart_time :arrive_date :arrive_time :cabin
    segment = response.trips.first.legs.first.segments.first
    assert_instance_of KayakFlightSearch::Segment, segment
    assert_equal "AB", segment.airline
    assert_equal "6749", segment.flight    
    assert_kind_of Numeric, segment.duration
    assert_equal 60, segment.duration
    assert_equal "Boeing 737-700", segment.equip
    assert_equal "-1", segment.miles
    assert_equal "HAM", segment.origin
    assert_equal "DUS", segment.destination
    assert_instance_of Time, leg.depart
    assert_instance_of Time, leg.arrive
    assert_equal "Economy", segment.cabin
  end

end