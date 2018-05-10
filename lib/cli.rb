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
		puts
		puts "================================="
		puts "'Exit' will stop data collection."
		puts "================================="
		puts
		
		until (input == "exit") do
			puts "Enter 'y' to pull wind and tide measurements at the #{self.location} location."
			puts "Enter 'yd' for more detail."
			puts
			puts "The NOAA service updates every 6 minutes."
			puts

			input = gets.strip.downcase
			puts

			if input == "y" || input == "yd"
				gwl = GetWaterLevel.new
				gwv = GetWind.new

				wl_data = gwl.pull_data(self.tideId)
				wv_data = gwv.pull_data(self.windId)
				
				wl = NOAA_SOAP.most_recent(wl_data)
				wv = NOAA_SOAP.most_recent(wv_data)
				
				puts "Wind Speed at #{wv[:time_stamp]} GMT:"
				puts "Wind speed is #{wv[:ws]} m\/s out of #{wv[:wd]} degrees."
				puts "Gusts to #{wv[:wg]} m\/s are reported." if input == 'yd'
				
				
				puts
				puts "Water level at #{wl[:time_stamp]} GMT:"
				puts "The water level is #{wl[:wl]} meters above/below sea level."
				puts "Water level standard deviation is #{wl[:sigma]} meters." if input == 'yd'
			end
			puts
		end
	end

private
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
