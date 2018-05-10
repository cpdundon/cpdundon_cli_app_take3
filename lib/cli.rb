require_relative './config'

class CLI
	
	attr_accessor :windID, :tideID, :windLocation, :tideLocation

	def initialize ()
		@windID = nil
		@tideID = nil
		@windLocation = nil
		@tideLocation = nil
	end
	
	def main()
		input = nil
		input = winds_decision
		puts input + " dropped out of winds_decision"
		return input if input == "exit"
		input = observation_cycle
		input
	end

private
	def winds_decision()
		input = nil
		iCaptured = nil
		puts
		puts "================================="
		puts "'Exit' will stop data collection."
		puts "================================="
		
		stations = GetActiveStations.winds
		stations = stations.sort {|x,y| x.name <=> y.name}

		sz = stations.size
		until (input == "exit" || iCaptured)	
			puts		
			puts "Enter the index number of the station you want to use."
			(1..sz).each do |i|
				puts "#{i}. Station named '#{stations[i-1].name}'."
			end
			puts
			puts "Enter the index number of the station you want to use."
			input = gets.strip.downcase
			iCaptured = (input == input.to_i.to_s) && input.to_i > 0 && input.to_i <= sz 
		end
		
		if input != "exit"
			sta = stations[input.to_i - 1]
			self.windLocation = sta.name
			self.windID = sta.iD
		end
	
		input	
	end	

	def observation_cycle()
		input = nil
		puts
		puts "================================="
		puts "'Exit' will stop data collection."
		puts "================================="
		puts
		
		until (input == "exit") do
			puts "Enter 'y' to pull wind and tide measurements."
			puts
			puts "***The NOAA Service Updates Every 6 Minutes***"
			puts

			input = gets.strip.downcase
			puts

			if input == "y"
				gwl = GetWaterLevel.new
				gwv = GetWind.new

				wl_data = gwl.pull_data(self.tideId)
				wv_data = gwv.pull_data(self.windId)
				
				wl = NOAA_SOAP.most_recent(wl_data)
				wv = NOAA_SOAP.most_recent(wv_data)
				
				puts "Using #{self.windLocation}:"
				puts "Wind Speed at #{wv[:time_stamp]} GMT:"
				puts "Wind speed is #{wv[:ws]} m\/s out of #{wv[:wd]} degrees."
				puts "Gusts to #{wv[:wg]} m\/s are reported."
				
				
				puts
				puts "Using #{self.tideLocation}:"
				puts "Water level at #{wl[:time_stamp]} GMT:"
				puts "The water level is #{wl[:wl]} meters above/below sea level."
				puts "Water level standard deviation is #{wl[:sigma]} meters."
			end
			puts	
		end
		input
	end
end
