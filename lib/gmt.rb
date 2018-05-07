require_relative './config'

class GMT
	def self.gmt_now
		t = Time.now.gmtime
		t.utc.strftime "%Y%m%d %H:%M"
	end

	def self.gmt_less_48h
		t = Time.now.gmtime - (2 * 24 * 60 * 60)
		t.utc.strftime "%Y%m%d %H:%M"			
	end
	
	def self.gmt_less_1h
		t = Time.now.gmtime - (60 * 60)
		t.utc.strftime "%Y%m%d %H:%M"			
	end
end

