require 'nokogiri'
require 'sinatra'
require 'open-uri'

class LookupFixApp < Sinatra::Base

  helpers do
    def build_url(waypoint)
      "https://nfdc.faa.gov/nfdcApps/services/ajv5/fix_search.jsp?keyword=#{waypoint}"
    end
  end

  get '/' do
    erb :index
  end

  post '/search' do
    @waypoints = {} 
    params[:waypoints].split(",").map do |waypoint|
      doc = Nokogiri::HTML(open(build_url(waypoint.strip)))
      @waypoints[waypoint] = doc.css('table tr').map do |row|
        row.xpath('td').map do |cell|
          "#{cell.text}"
        end
      end
    end
    erb :search
  end

end
