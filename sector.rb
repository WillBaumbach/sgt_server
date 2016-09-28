
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# sector.rb:
#	Fixed size piece of the world container 


require_relative 'redisobject'
require_relative 'world'
require_relative 'solarsystem'


# Fixed size piece of the world container 
class Sector < RedisObject
	
	# Member Variables
	
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
	
	# generates a new solar system part of this sector
	def generateNewSolarSystem(x, y)
		system = newSolarSystem(@db, self, x, y)
		key = x.to_s+','+y.to_s
		@db.hset('sgt-sector:'+@id+':systems', key, system.id)
		
		system.generate
	end

	# generates a random new sector
	def generate()
		
		generateNewSolarSystem(500, 500)
		
		# TODO: Lots
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

