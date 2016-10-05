
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# solarsystem.rb:
#	A solar system contained within one sector


require_relative 'redisobject'
require_relative 'sector'


# Fixed size piece of the world container 
class SolarSystem < RedisObject
	
	# Member Variables
	
	# returns the center x offset
	def centerX
		@db.hget('sgt-system:' + @id, 'centerx').to_i
	end
	
	# returns the center y offset
	def centerY
		@db.hget('sgt-system:' + @id, 'centery').to_i
	end
	
	# returns a reference to the sector this solar system belongs to
	def sector
		sid = @db.hget('sgt-system:' + @id, 'sector')
		Sector.new(@db, sid)
	end
	
	# List of celestial bodies visible at zoomed out level (stars)
	def distantCelestialBodies
		ret = []
		@db.hgetall('sgt-system:' + @id + ':distantbodies').each do |coords, bid|
			ret.push(CelestialBody.new(@db, bid))
		end
		ret
	end
	
	# list of all celestial bodies in solar system
	def celestialBodies
		ret = []
		@db.hgetall('sgt-system:' + @id + ':bodies').each do |coords, bid|
			ret.push(CelestialBody.new(@db, bid))
		end
		ret
	end

	# generates a random new solar system
	def generate()
		
		# first generate at least one star
		
		# possibly another star
		
		# for each planet:
		# newCelestialBody(..., 'planet')
		# celestialbody.generate
		
	end
	
end


# generates a new sector object at a given position in a given sector
def newSolarSystem(db, sector, x, y)
	newId = newUUID(db)
	@db.hset('sgt-system:' + newId, 'sector', sector.id)
	@db.hset('sgt-system:' + newId, 'centerx', x)
	@db.hset('sgt-system:' + newId, 'centery', y)
	
	system = SolarSystem.new(db, newId)
	system
end


