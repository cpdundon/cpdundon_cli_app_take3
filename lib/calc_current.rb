require_relative './config'

# ========================================================
# This is proof of concept code.  It can be extended
# to allow for a great deal more realistic take on 
# estuary currents. CPD - 12-May-2018
# ========================================================

class CalcCurrent
	
	include Math
	attr_reader :depth_delta

	Gamma = 0.005 #Tanh scale factor
	Depth = 25 #Meters 
	Estuary_Width = 1000 #Meters
	Estuary_Length = 115000 #Meters
	Shaft_Radius = 5000 #Meters
	Meters_Knots = 1.94384 #Meter/Sec to Knots		
	SixMin_Secs = 360

	@@static_data = []
	@@tanh_fac = nil
	
	def self.static
		@@static_data
	end

	def self.t_fac
		@@tanh_fac
	end

	def initialize
		return if self.class.static.size != 0		
		@@tanh_fac = tanh_normalization_factor
		static_bootstrap
	end

	def calc_surface_current(location, depth_delta = nil)
		@depth_delta = depth_delta / SixMin_Secs if !!depth_delta
		
		return "Missisng Depth Delta information."  if !!!self.depth_delta
		
		depth = depth_from_loc(location) # this maps location to a depth from radial tdc in the river channel.
		
		stat = self.class.static
		rdh = stat.select { |e| e.depth == depth }[0]
		
		surf_current = self.depth_delta * rdh.normalized_tanh * Estuary_Length
		
		rdu = RiverData_Surf.new
		rdu.tdc_radius = Shaft_Radius
		rdu.c_velocity_ms = surf_current
		rdu.c_velocity_kts = surf_current * Meters_Knots	
		rdu.surf_loc = location
		rdu.surf_radius = rdh.depth_radius

		rdu
	end

private
	def tanh_normalization_factor
		tnf = 0
		(0..Depth).each do |i|
			tnf += tanh(Gamma * i)
		end 
		tnf
	end

	def static_bootstrap
		(0..Depth).each do |i|
			rdh = RiverData_Shaft.new
			rdh.depth = Depth - i
			rdh.height = i
			rdh.depth_radius = Shaft_Radius - i
			rdh.normalized_tanh = tanh(Gamma * i) / self.class.t_fac
			self.class.static << rdh
		end
	end

	def depth_from_loc(loc)
		l = loc.abs
		r_tdc = Shaft_Radius - Depth
		theta = atan(l/r_tdc)
		shaft_r_loc = r_tdc / cos(theta)
		depth = (shaft_r_loc - r_tdc).floor
		depth
	end
	
end

class RiverData_Shaft
	attr_accessor :depth, :height, :depth_radius, :normalized_tanh
end

class RiverData_Surf
	attr_accessor :surf_radius, :surf_loc, :c_velocity_ms, :c_velocity_kts, :tdc_radius
end
