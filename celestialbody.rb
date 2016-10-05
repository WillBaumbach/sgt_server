
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# celestialbody.rb:
#	Defines a natural object in space (planet, star, astroid, etc)


require_relative 'redisobject'
require_relative 'solarsystem'

require_relative 'celestialstar'
require_relative 'celestialplanet'


# Fixed size piece of the world container 
class CelestialBodyAbstract < RedisObject
	
	# Member Variables
	
	
	# returns x coordinate
	def x
		@db.hget('sgt-cbody:' + @id, 'x').to_i
	end
	
	# returns y coordinate
	def y
		@db.hget('sgt-cbody:' + @id, 'y').to_i
	end
	
	# returns the body radius
	def radius
		@db.hget('sgt-cbody:' + @id, 'radius').to_i
	end
	
	# returns a reference to the solar system body belongs to
	def solarsystem
		sid = @db.hget('sgt-cbody:' + @id, 'system')
		SolarSystem.new(@db, sid)
	end
	
	# Generates new (absract)
	def generate()
	
	end
	
end

# class Planet : CelestialBody


# Returns the correct class of job based on the db type
def getCelestialBody(db, cbid)
	cb = CelestialBodyAbstract.new(db, cbid)
	type = cb.type
	
	if type == 'star'
		return CelestialStar.new(db, cbid)
	else
		return CelestialPlanet.new(db, cbid)
	end
	
	cb
end


def newCelestialBody(db, solarsystem, x, y, type)
	newId = newUUID(db)
	@db.hset('sgt-cbody:' + newId, 'type', type)
	@db.hset('sgt-cbody:' + newId, 'system', solarsystem.id)
	@db.hset('sgt-cbody:' + newId, 'x', x)
	@db.hset('sgt-cbody:' + newId, 'y', y)
	
	getCelestialBody(db, newId)
end
