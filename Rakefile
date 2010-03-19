require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('kayak_flight_search', '0.5.0') do |p|
  p.description     = "Uses api.kayak.com for a Flightsearch from and to a given Airport-iata_code"
  p.url             = "http://github.com/henningthies/kayak_flight_search"
  p.author          = "Henning Thies"
  p.email           = "thies@ubilabs.net"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = ['nokogiri']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{ |ext| load ext }