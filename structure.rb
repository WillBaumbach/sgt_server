# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
#
# structure.rb:
#	Something something structure


require_relative 'redisobject'
require_relative 'unit'
require_relative 'job'
require_relative 'inventory'


# Look at UnitLocation (Unit) Class for format
#	Celestial body?
#	Celestial body (Access)
#	Space (Astrolocation)
#	Space?
#	setSpace
#	setCelestialBody
#	

class StructureLocation
	
	#Initialize Database and ID
	def initialize 
		@id = id
		@db = db
	end
	
	# Internal Representation
	def rawString
		s = @db.hget('sgt-structure:' + @id, 'loc')
		if s == nil || s == ''
			return 'a:0:0,0'
		end
		return s
	end


	# Internal Representation
	def setRawString(str)
		@db.hset('sgt-structure:' + @id, 'loc', str)
	end

	# Returns an astrolocation reference
	def space
		AstroLocation.new(@db, rawString)
	end


	# Returns if the structure is in space
	def space?
		rawString.start_with? 'a'
	end

	# Sets location of structure as an astrolocation
	def setSpace(astro)
		setRawString.(astro.to_s)
	end
	
	# Returns a celestial body reference
	def celestialBody
		args = rawString.split(':')
		cid = args[1]
		getCelestialBody(@db, cid)
	end 
	
	
	# Returns if the structure is anchored to a celestial body
	def celestialBody?
		rawString.start_with? 'c'
	end
	
	# Sets the structure location to a celestial body
	def setCelestialBody(body)
		setRawString('c:' + body.id)
	end

end



#DB.hget for most methods
class Structure < RedisObject
	
	#Member Variables
	#	name?
	
	
	#
	def owner()
		
	end
	
	
	#
	def hp()
		
	end
	
	
	# List of all the units contained by a structure
	def units
		ret = []
		@db.smembers('sgt-structure:' + @id + ':units').each do |uid|
			ret.push(getUnit(@db, uid))
		end
		ret
	end
	
	
	# returns the inventory this structure contains
	def inventory()
		Inventory.new(@db, 'sgt-structure:' + @id + ':inv')
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


