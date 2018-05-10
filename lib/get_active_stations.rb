require_relative './config'

class GetActiveStations < NOAA_SOAP
	
	#WSDL = "https://opendap.co-ops.nos.noaa.gov/axis/services/ActiveStations?wsdl"
	WSDL = '../run_support/ActiveStations.xml'	


	def initialize
		super WSDL
	end
	
	def client
		super	
	end

	def pull_data
		message = {soap_action: "Body"}
		reaponse = self.client.call(:get_active_stations_v2, message) #, soap_action: '"urn:ActiveStationsV2"')
		
		#response = self.pull_response(:get_active_stations_v2, message)
		#response.to_hash[:wind_measurements][:data][:item] #this returns a hash of the data points.
		response
	end
	
end
