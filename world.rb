
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# world.rb:
#	Container for entire map


require_relative 'redisobject'
require_relative 'sector'


# Object containing all map element in tree structure
class World < RedisObject
	
	# Member Variables
	# @id : Database id
	# @valid : Validity flag

	# returns a list of all sectors in world
	def sectors
		ret = []
		@db.smembers('sgt-world:' + @id + ':sectors').each do |sid|
			ret.push(Sector.new(@db, sid))
		end
	end
	
	# generates sector at index x,y in this world
	def generateSector(sid, x, y)
		sector = Sector.new(@db, sid)
		sector.generate(self, x, y)
		
		@db.sadd('sgt-world:' + @id + ':sectors', sid)
	end

	
	
end

