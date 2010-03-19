class KayakFlightSearch::Result
  
  attr_reader :session_id
  attr_reader :search_id 
  attr_reader :response
  
  def initialize (session_id, search_id)
    @session_id = session_id
    @search_id = search_id
    @api_url = "http://api.kayak.com"
    get_results
  end
  
  def get_results
    url = @api_url + "/s/apibasic/flight?searchid=#{@search_id}&s=price&c=10&apimode=1&_sid_=#{@session_id}"
    begin
      response = Net::HTTP.get_response(URI.parse(url)).body.to_s
    rescue => e
      raise RuntimeError.new("failed to get results [url=#{url}, e=#{e}].")
    end
    
    doc = Nokogiri::XML.parse(response)
    @response = KayakFlightSearch::Response.new(doc)
  end  
end