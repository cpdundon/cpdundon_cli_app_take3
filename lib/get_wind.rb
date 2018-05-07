require_relative './config'

class GetWind < NOAA_SOAP
	
	WSDL = "https://opendap.co-ops.nos.noaa.gov/axis/webservices/wind/wsdl/Wind.wsdl"

	def initialize
		super WSDL
	end
	
	def client
		super	
	end

	def pull_data (station_id = 8454000)
		message = {stationId: station_id.to_s, beginDate: GMT.gmt_less_1h, endDate: GMT.gmt_now, \
			unit: "Meters", timeZone: 0}
		
		response = self.pull_response(:get_wind_and_metadata, message)
		response.to_hash[:wind_measurements][:data][:item] #this returns a hash of the data points.
	end
	
end
