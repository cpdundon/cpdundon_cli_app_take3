require_relative './config'

class NOAA_SOAP
	attr_reader :client	
	
	def self.most_recent(data)
		d = data.sort { |x,y| y[:time_stamp] <=> x[:time_stamp] }[0]
		d
	end

	def initialize(wsdl = "https://opendap.co-ops.nos.noaa.gov/axis/webservices/waterlevelrawsixmin/wsdl/WaterLevelRawSixMin.wsdl")
		create_client(wsdl)
	end
	
	def pull_response(operation, message)		
		response = self.client.call(operation, message: message)
		response
	rescue Savon::SOAPFault => error
	    fault_code = error.to_hash[:fault][:faultcode]
	    raise CustomError, fault_code
	end

private
	def create_client(wsdl)
		client = Savon.client(wsdl: wsdl, \
				open_timeout: 30, \
				read_timeout: 30, \
				log: false, \
				follow_redirects: true)

		@client = client
		self.client
	end	
end
