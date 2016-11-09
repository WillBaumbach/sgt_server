
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# solarsystem.rb:
#	A solar system contained within one sector


require_relative 'redisobject'
require_relative 'sector'
require_relative 'celestialbody'


# Fixed size piece of the world container 
class SolarSystem < RedisObject
	
	# Member Variables
	
	# Constants
	SolarSystemRadius = 0.5e13
	ProbabilitySecondStar = 0.2
	MinBodyDist = 1e11
	MedianNumPlanets = 5
	NumPlanetsVariation = 2
	
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
			ret.push(getCelestialBody(@db, bid))
		end
		ret
	end
	
	# list of all celestial bodies in solar system
	def localCelestialBodies
		ret = []
		@db.hgetall('sgt-system:' + @id + ':bodies').each do |coords, bid|
			ret.push(getCelestialBody(@db, bid))
		end
		ret
	end
	
	def celestialBodies
		distantCelestialBodies + localCelestialBodies
	end
	
	# Returns all celestial bodies which may cover the given radius
	def celestialBodiesWithin(x, y, rad)
		ret = []
		celestialBodies.each do |cb|
			dist = Math.sqrt((x - cb.x)**2 + (y - cb.y)**2)
			puts 'cb Trying: ' + dist.to_s
			if dist <= rad
				ret.push cb
			end
		end
		ret
	end

	# generates a new solar system part of this sector
	def generateNewCelestialBody(x, y, type)
		cb = newCelestialBody(@db, self, x, y, type)
		key = cb.x.to_s+','+cb.y.to_s
		
		# Is it seen from a distance?
		if type == 'star'
			@db.hset('sgt-system:'+@id+':distantbodies', key, cb.id)
		else
			@db.hset('sgt-system:'+@id+':bodies', key, cb.id)
		end

		cb.generate
		cb
	end

	# returns a position far enough from all other celestial bodies
	def randomDistantPosition()
		cx = centerX
		cy = centerY
		# make sure it's far enough from every other system
		otherbodies = celestialBodies
		
		loop do
			pos = randomLocation(cx, cy, SolarSystemRadius)
			
			ok = true
			if otherbodies.empty?
				return pos
			end
			otherbodies.each do |cb|
				dist = Math.sqrt((pos[0] - cb.x)**2 + (pos[1] - cb.y)**2)
				if dist < MinBodyDist
					ok = false
					break
				end
			end
			if ok
				return pos
			end
		end
	end

	# generates a random new solar system
	def generate()
		# first generate at least one star
		
		cx = centerX
		cy = centerY
		starPos = randomLocation(cx, cy, SolarSystemRadius)
		star = generateNewCelestialBody(starPos[0], starPos[1], 'star')
		
		# possibly another star
		if rand < ProbabilitySecondStar
			starPos2 = randomDistantPosition
			star2 = generateNewCelestialBody(starPos2[0], starPos2[1], 'star')
		end
		
		numPlanets = Random.rand(MedianNumPlanets-NumPlanetsVariation...MedianNumPlanets+NumPlanetsVariation)
		numPlanets.times do
			planetPos = randomDistantPosition
			planet = generateNewCelestialBody(planetPos[0], planetPos[1], 'planet')
		end
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


