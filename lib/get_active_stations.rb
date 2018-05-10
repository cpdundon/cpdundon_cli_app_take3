require_relative './config'

class GetActiveStations

	FILE_PATH = "../run_support/responseStations.xml"	

	@@doc = []
	@@water_level = []
	@@winds = []	

	def self.water_level
		self.pull_data if @@water_level.size == 0		
		@@water_level
	end

	def self.winds
		self.pull_data if @@winds.size == 0		
		@@winds
	end

private
	def self.doc
		@@doc
	end


	def self.pull_data
		@@doc = []
		@@water_level = []
		@@winds = []
		
		@@doc = File.open(FILE_PATH) { |f| Nokogiri::XML(f) }

		stations = self.doc.xpath("//stationV2")		
		stations.each_entry do |e|
			iD = e.xpath(".").attribute("ID").value
			name = e.xpath(".").attribute("name").value			

			state = e.xpath("./metadataV2/location/state")[0].text
			local = ((state == "NY") || (state == "NJ") || (state == "CT"))		
						
			water = e.xpath("./parameter[contains(@name, 'Water Level')]")
			wind = e.xpath("./parameter[contains(@name, 'Winds')]")
			
			@@winds << {:name => name, :iD => iD, :state => state} if local && wind.size > 0
			@@water_level << {:name => name, :iD => iD, :state => state} if local && water.size > 0	
		end
	end	
end
