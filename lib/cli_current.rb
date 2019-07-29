require_relative './config'

class CLICurrent
	
	attr_accessor :windID, :tideID, :windLocation, :tideLocation

	def initialize ()
		@windID = nil
		@tideID = nil
		@windLocation = nil
		@tideLocation = nil
	end
	
	def main()
		input = nil

		input = decision("tide")
		return input if input == "exit"

		input = current_cycle
		input
	end

private
	def decision(flag)
		input = nil
		iCaptured = nil
		puts
		puts "================================="
		puts "'Exit' will stop data collection."
		puts "================================="
		
		if flag.strip.downcase == "winds"
			stations = GetActiveStations.winds
		else
			stations = GetActiveStations.water_level
		end

		stations = stations.sort {|x,y| x.name <=> y.name}

		sz = stations.size
		until (input == "exit" || iCaptured)	
			puts		
			puts "Enter the index number of the #{flag.upcase} station you want to use."
			(1..sz).each do |i|
				puts "#{i}. Station named '#{stations[i-1].name}'."
			end
			puts
			puts "Enter the index number of the #{flag.upcase} station you want to use."
			input = gets.strip.downcase
			iCaptured = (input == input.to_i.to_s) && input.to_i > 0 && input.to_i <= sz 
		end
		
		if input != "exit" && flag == "winds"
			sta = stations[input.to_i - 1]
			self.windLocation = sta.name
			self.windID = sta.iD
		elsif input != "exit"
			sta = stations[input.to_i - 1]
			self.tideLocation = sta.name
			self.tideID = sta.iD		
		end
	
		input	
	end	

	def current_cycle()
		input = nil
		puts
		puts "======================================="
		puts "'Exit' will terminate this application."
		puts "======================================="
		puts
		
		
		gwl = GetWaterLevel.new
		wl_data = gwl.pull_data(self.tideID)
		wl_chg_data = NOAA_SOAP.most_recent(wl_data, 2)
		wl_delta_6min = wl_chg_data[0][:wl].to_f - wl_chg_data[1][:wl].to_f		
		t = wl_chg_data[0][:time_stamp]

		cc = CalcCurrent.new

		until (input == "exit") do
			puts "Enter your location in meters away from center channel (-500...500)."
			puts "OR..."
			puts "Enter 'New' to query NOAA for the latest water level measurement."			
			puts
			puts "***The NOAA Service Updates Every 6 Minutes***"
			puts

			input = gets.strip.downcase
			puts

			if input == input.to_i.to_s && input.to_i >= -500 && input.to_i <= 500				
				
				rdu = cc.calc_surface_current(input.to_i, wl_delta_6min)
				return "Error" if rdu.class != RiverData_Surf

				kts = rdu.c_velocity_kts
				
				puts "Using #{self.tideLocation} at #{t.slice(0, t.length-5)} GMT:"
				puts "The 6 minute water level difference is #{'%.3f' %wl_delta_6min} meters:"
				puts "The current #{input} meter(s) away from center channel is #{'%.2f' %kts} knots."
			end

			if input == "new"
				gwl = GetWaterLevel.new
				wl_data = gwl.pull_data(self.tideID)
				wl_chg_data = NOAA_SOAP.most_recent(wl_data, 2)
				wl_delta_6min = wl_chg_data[0][:wl].to_f - wl_chg_data[1][:wl].to_f						
				t = wl_chg_data[0][:time_stamp]
				puts
				puts "The new data has a time stamp of #{t.slice(0, t.length-5)} GMT."
			end 

			puts	
		end
		input
	end
end
