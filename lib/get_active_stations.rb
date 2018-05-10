require_relative './config'

class GetActiveStations
	
	@@doc = []
	@@water_level = []
	@@winds = []	

	FILE_PATH = "../run_support/responseStations.xml"

	def initialize
		self.class.pull_data
	end
	
	def self.doc
		self.pull_data if @@doc == []
		@@doc
	end

	def self.water_level
		self.pull_data if @@wind_level == []		
		@@water_level
	end

	def self.winds
		self.pull_data if @@winds == []		
		@@winds
	end

private
	def self.pull_data
		@@doc = []
		@@water_level = []
		@@winds = []
		
		@@doc = File.open(FILE_PATH) { |f| Nokogiri::XML(f) }

		stations = self.class.doc.xpath("//stationV2")		
		stations.each_entry do |e|
			state = e.xpath("./metadataV2/location/state")[0].text
			local = ((state == "NY") || (state == "NJ") || (state == "CT"))		
						
			water = e.xpath("./parameter[contains(@name, 'Water Level')]")
			wind = e.xpath("./parameter[contains(@name, 'Winds')]")
			
			@@winds << e.xpath(".") if local && wind.size > 0
			@@water_level << e.xpath(".") if local && water.size > 0	
		end
	end	
end
