require_relative './config'

class NOAA_SOAP
	attr_reader :client	
	
	def self.most_recent(data, count = 1)
		rtn = []
		d = data.sort { |x,y| y[:time_stamp] <=> x[:time_stamp] }
		
		(1..count).each do |i|
			rtn << d[i - 1]
		end
		rtn
	end

	def initialize(wsdl)
		create_client(wsdl)
	end
	
	def pull_response(operation, message = nil)
		if !!message		
			response = self.client.call(operation, message: message)
		else
			response = self.client.call(operation)
		end

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

class CustomError < StandardError
	def initialize(msg)
		super
	end
end
