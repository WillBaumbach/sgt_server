# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
#
# structure.rb:
#	Something something structure


require_relative 'redisobject'
require_relative 'unit'
require_relative 'job'


class Structure < RedisObject
	
	#Member Variables
	#	name?
	
	def initialize
		
	end
	
	
	#
	def owner()
	
	end
	
	
	#
	def hp()
	
	end
	
	
	# List of all the units contained by a structure
	def units
		ret = []
		@db.hgetall('sgt-structure:' + @id + ':units').each do |coords, sid|
			ret.push(Unit.new(@db, sid))
		end
		ret
	end
	
	
	#
	def inventory()
	
	end
	
	
	#
	def commRadius()
	
	end
	
	
	#
	def location()
	
	end
	
	
	#
	def tick()
	
	end
	
	
	
	
end


