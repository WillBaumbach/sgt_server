# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# player.rb:
#	Player in the world


require_relative 'redisobject'
require_relative 'sector'
require_relative 'utility'


class PlayerLocation
	def initialize(db, id)
		@id = id
		@db = db
	end
	
	# internal representation
	def rawString
		s = @db.hget('sgt-player:'+@id, 'loc')
		if s == nil || s == ''
			return 'a:0:0,0'
		end
		return s
	end
	
	# internal representation
	def setRawString(str)
		@db.hset('sgt-player:'+@id, 'loc', str)
	end
	
	# sets location as an astrolocation
	def setSpace(astro)
		setRawString(astro.to_s)
	end
	
end


# Player in the world
class Player < RedisObject
	
	# Member Variables

	# returns a location reference for where this unit is
	def location
		UnitLocation.new(@db, @id)
	end
	
	# Player connected to the game -> set up message processing
	def connected(client)
		client.listen('WHEREAMI?', self)
	end
	
	# For handling client requests
	def onRequest(req)
		if req.request == 'WHEREAMI?'
			req.reply('YOURPOS', '0,0:0,0')
		end
	end
	
end

