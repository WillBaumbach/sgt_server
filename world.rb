
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# world.rb:
#	Container for entire map


require_relative 'redisobject'
require_relative 'sector'
require_relative 'utility'

# Object containing all map element in tree structure
class World < RedisObject
	
	# Member Variables


	# returns a list of all sectors in world
	def sectors
		ret = []
		@db.hgetall('sgt-world:' + @id + ':sectors').each do |coords, sid|
			ret.push(Sector.new(@db, sid))
		end
		ret
	end
	
	# gets or generates sector at index x,y in this world
	def getSector(x, y)
		sectorsKey = 'sgt-world:' + @id + ':sectors'
		sectorKey = x.to_s+','+y.to_s
		if @db.hexists(sectorsKey, sectorKey)
			sid = @db.hget(sectorsKey, sectorKey)
			sector = Sector.new(@db, sid)
			return sector
		end
	
		sector = newSector(@db, self, x, y)
		@db.hset(sectorsKey, sectorKey, sector.id)
		sector.generate
		sector
	end

	# returns the associated name of the world
	def name
		@db.hget('sgt-world:'+@id, 'name')
	end
	
	
end

# creates a new world object associated with a given name
def newWorld(db, name)
	if db.hexists('sgt-worlds', name)
		return World.new(db, db.hget('sgt-worlds', name))
	end
	newId = newUUID(db)
	
	# Associate this name to the world id
	db.hset('sgt-worlds', name, newId)
		
	# The 'name' property of the object
	db.hset('sgt-world:'+newId, 'name', name)
	
	world = World.new(db, newId)
	world
end


