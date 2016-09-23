
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# sector.rb:
#	Fixed size piece of the world container 


require_relative 'redisobject'
require_relative 'world'


# Fixed size piece of the world container 
class Sector < RedisObject
	
	# Member Variables
	
	# returns whether this sector was already generated
	def exists?
		@db.exists('sgt-sector:' + @id)
	end
	
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

	# generates a random new sector at index x,y
	def generate(world, x, y)
		return if exists?
	
		@db.hset('sgt-sector:' + @id, 'world', world.id)
		@db.hset('sgt-sector:' + @id, 'offsetx', x)
		@db.hset('sgt-sector:' + @id, 'offsety', y)
		
		# TODO: Lots
	end
	
end

