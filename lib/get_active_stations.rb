require_relative './config'

class GetActiveStations < NOAA_SOAP
	
	WSDL = "https://opendap.co-ops.nos.noaa.gov/axis/services/ActiveStations?wsdl"

	def initialize
		super WSDL
	end
	
	def client
		super	
	end

	def pull_data
		message = {urn: "ActiveStations"}
		
		response = self.pull_response(:get_active_stations_v2, message)
		#response.to_hash[:wind_measurements][:data][:item] #this returns a hash of the data points.
		response
	end
	
end