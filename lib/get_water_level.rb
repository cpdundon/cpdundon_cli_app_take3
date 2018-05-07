require_relative './config'

class GetWaterLevel < NOAA_SOAP
	
	WSDL = "https://opendap.co-ops.nos.noaa.gov/axis/webservices/waterlevelrawsixmin/wsdl/WaterLevelRawSixMin.wsdl"

	def initialize
		super WSDL
	end
	
	def client
		super	
	end

	def pull_data (station_id = 8454000)
		message = {stationId: station_id.to_s, beginDate: GMT.gmt_less_1h, endDate: GMT.gmt_now, \
			datum: "MLLW", unit: 0, timeZone: 0}
		
		response = self.pull_response(:get_wl_raw_six_min_and_metadata, message)
		response.to_hash[:water_level_raw_six_min_measurements][:data][:item] #this returns a hash of the data points.
	end
	
end
