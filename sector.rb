
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# sector.rb:
#	Fixed size piece of the world container 


require_relative 'redisobject'
require_relative 'world'
require_relative 'solarsystem'


class AstroLocation
	
	# Member Variables
	# @sector : Sector Reference
	# @x : X offset
	# @y : Y offset
	
	# creates by parsing string
	# Format: 'a:sec#:x,y'
	def initialize(s)
		args = s.split(':')
		xyargs = args[2].split(',')
		@sector = Sector.new($db, args[1])
		@x = xyargs[0].to_i
		@y = xyargs[1].to_i
	end
	
	# returns sector ref
	def sector
		@sector
	end
	
	# returns x coord
	def x
		@x
	end
	
	# returns y coord
	def y
		@y
	end
	
	def to_s
		'a:' + @sector.id + ':' + x.to_s + ',' + y.to_s
	end
	
end

def astroLocationFromCoords(sector, x, y)
	AstroLocation.new('a:' + sector.id + ':' + x.to_s + ',' + y.to_s)
end


# Fixed size piece of the world container 
class Sector < RedisObject
	
	# Member Variables
	
	# Constants
	MinSystemDistance = 5 * SolarSystem::SolarSystemRadius
	MedianNumSolarSystems = 7
	NumSolarSystemsVariation = 5
	SectorSpan = 5e15
	
	
	# returns the x index of this sector (0 is center)
	def offsetX
		@db.hget('sgt-sector:' + @id, 'offsetx').to_i
	end
	
	# returns the y index of this sector (0 is center)
	def offsetY
		@db.hget('sgt-sector:' + @id, 'offsety').to_i
	end
	
	# returns a reference to the world this sector belongs to
	def world
		wid = @db.hget('sgt-sector:' + @id, 'world')
		World.new(@db, wid)
	end
	
	# returns a list of all solar systems in this sector
	def solarsystems
		ret = []
		@db.hgetall('sgt-sector:' + @id + ':systems').each do |coords, sid|
			ret.push(SolarSystem.new(@db, sid))
		end
		ret
	end
	
	# Returns all solar systems which may cover the given radius
	def solarsystemsWithin(x, y, rad)
		ret = []
		solarsystems.each do |system|
			dist = Math.sqrt((x - system.centerX)**2 + (y - system.centerY)**2)
			if dist <= rad + SolarSystem::SolarSystemRadius
				ret.push system
			end
		end
		ret
	end
	
	# generates a new solar system part of this sector
	def generateNewSolarSystem(x, y)
		system = newSolarSystem(@db, self, x, y)
		key = x.to_s+','+y.to_s
		@db.hset('sgt-sector:'+@id+':systems', key, system.id)
		
		system.generate
	end

	# generates a random new sector
	def generate()
		numSystems = Random.rand(MedianNumSolarSystems-NumSolarSystemsVariation...MedianNumSolarSystems+NumSolarSystemsVariation)
		numSystems.times do
			# repeat until successful
			loop do
				# A sector ranges from -5e15 -> 5e15 on both xy axis
				xcenter = Random.rand(-SectorSpan...SectorSpan)
				ycenter = Random.rand(-SectorSpan...SectorSpan)
				
				# make sure it's far enough from every other system
				othersystems = solarsystems
				ok = true
				othersystems.each do |othersystem|
					dist = Math.sqrt((xcenter - othersystem.centerX)**2 + (ycenter - othersystem.centerY)**2)
					if dist < MinSystemDistance
						ok = false
						break
					end
				end
				if ok
					generateNewSolarSystem(xcenter, ycenter)
					break
				end
			end
		end
	end
	
end


# generates a new sector object at a given index in a given world
def newSector(db, world, x, y)
	newId = newUUID(db)
	@db.hset('sgt-sector:' + newId, 'world', world.id)
	@db.hset('sgt-sector:' + newId, 'offsetx', x)
	@db.hset('sgt-sector:' + newId, 'offsety', y)
	
	sector = Sector.new(db, newId)
	sector
end


#Test

