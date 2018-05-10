require_relative './config'

class Station
	attr_accessor :state, :handle, :name, :water_level, :winds, :iD

	def initialize
		self.handle = nil
		self.name = nil
		self.water_level = nil
		self.winds = nil
		self.iD = nil
		self.state = nil
	end
end
