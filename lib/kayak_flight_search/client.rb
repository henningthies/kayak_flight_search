class KayakFlightSearch::Client

  attr_reader :session_id
  attr_reader :search_id
  
  @@API_URL = "http://api.kayak.com"
  
  def initialize (api_url = @@API_URL)
    @api_url = api_url
    @api_key = ENV['KAYAK_API_KEY'] 
    _start_session
  end
  
  def lookup (options = {})
    options.assert_valid_keys :depart_date, :depart_time, :return_time,  :return_date, :depart_airport, :arrival_airport, :oneway, :travelers, :cabin, :nearbyO, :nearbyD
    
    default_options = {
      :sid => @session_id, 
      :depart_date => Date.today.beginning_of_month.next_month, 
      :depart_time => "a", 
      :return_date => Date.today.beginning_of_month.next_month + 7.days,
      :return_time => "a", 
      :oneway => "n",
      :travelers => "2",
      :cabin => "e",
      :nearbyO => 1,
      :nearbyD => 1 
    }
    options.reverse_merge!(default_options)
    url = @api_url+ "/s/apisearch?basicmode=true&oneway=#{options[:oneway]}&origin=#{options[:depart_airport]}&destination=#{options[:arrival_airport]}&depart_date=#{KayakFlightSearch.format_date(options[:depart_date])}&depart_time=#{options[:depart_time]}&&return_date=#{KayakFlightSearch.format_date(options[:return_date])}&return_time=#{options[:return_time]}&travelers=#{options[:travelers]}&cabin=#{options[:cabin]}&&nearbyO=#{options[:nearbyO]}&nearbyD=#{options[:nearbyD]}&action=doflights&apimode=1&_sid_=#{options[:sid]}"
    _lookup(options[:depart_airport], options[:arrival_airport], url)
  end
  
  private
  
    def _start_session
      url = @api_url+"/k/ident/apisession?token="+@api_key
      begin
        response = Net::HTTP.get_response(URI.parse(url)).body.to_s
        xml = Nokogiri::XML.parse(response)    
        @session_id = xml.xpath('//sid').text
      rescue => e
        raise RuntimeError.new("failed to start session [url=#{url}, e=#{e}].")
      end
    end

    def _lookup (depart_airport, arrival_airport, url)
      begin
        response = Net::HTTP.get_response(URI.parse(url)).body.to_s
        xml = Nokogiri::XML.parse(response)
        @search_id = xml.xpath("//searchid").text
        raise xml.xpath('/error/message').text if @search_id == ""

        KayakFlightSearch::Result.new(@session_id, @search_id)
      rescue => e
        raise RuntimeError.new("failed to get search_id [depart_airport=#{depart_airport}, arrival_airport=#{arrival_airport}, url=#{url},  e=#{e}].")
      end
    end
  
  
end