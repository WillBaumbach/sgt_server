# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# player.rb:
#	Player in the world


require_relative 'redisobject'
require_relative 'sector'
require_relative 'utility'
require 'json'


class PlayerLocation
	D = 1000000000
	
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
	
	# returns an astrolocation reference
	def space
		AstroLocation.new(rawString)
	end

end


# Player in the world
class Player < RedisObject
	
	# Member Variables

	# returns a location reference for where this unit is
	def location
		PlayerLocation.new(@db, @id)
	end
	
	def inventory
		Inventory.new(@db,@id)
	end
	
	
	# Player connected to the game -> set up message processing
	def connected(client)
		client.listen('WHEREAMI?', self)
		client.listen('NEARBY?', self)
		client.listen('DISTANT?', self)
	end
	
	# For handling client requests
	def onRequest(req)
		if req.request == 'WHEREAMI?'
			loc = location.space
			resp = {:x => loc.x, :y => loc.y, :sectorx => loc.sector.offsetX, :sectory => loc.sector.offsetY}.to_json
			req.reply('YOURPOS', resp)
		elsif req.request == 'NEARBY?'
			distOfSight = req.message.to_i
			distOfSight = SolarSystem::SolarSystemRadius if distOfSight > SolarSystem::SolarSystemRadius
			distOfSight = 1000 if distOfSight < 1000
			
			resp = []
			loc = location.space
			loc.sector.solarsystemsWithin(loc.x, loc.y, distOfSight).each do |system|
				system.celestialBodiesWithin(loc.x, loc.y, distOfSight).each do |cb|
					bodyinfo = {:x => cb.x, :y => cb.y, :type => cb.type}
					resp.push bodyinfo
				end
			end
			req.reply('NEARBY', {:cbs => resp}.to_json)
		elsif req.request == 'DISTANT?'
			loc = location.space
			resp = []
			loc.sector.solarsystems().each do |system|
				system.distantCelestialBodies.each do |cb|
					bodyinfo = {:x => cb.x, :y => cb.y, :type => 'star'}
					resp.push bodyinfo
				end
			end
			req.reply('DISTANT', {:cbs => resp}.to_json)
		elsif req.request == 'RESOURCES'
			resourceinfo = {}
			celestialbody = getCelestialBody(@db, req.getmessage())
			if (celestialbody.solarsystem.sector == location.space.sector)
				dist = Math.sqrt((location.space.x - celestialbody.x)^2 + (location.space.y - celestialbody.y)^2)
				if (dist <= D)
					resourceinfo = celestialbody.inventory.resources.to_json
				end
			end
			req.reply('RESOURCES', resourceinfo)
		elsif req.request == 'INVENTORY'
			invinfo = inventory.resources.to_json	
			req.reply('INVENTORY', invinfo)
		elsif req.request == 'IMOVED'
			
		end
	end
	
end


# Gets a player instance, creating new profile if necessary
def getPlayer(db, id)
	if db.exists('sgt-player:'+id)
		return Player.new(db, id)
	else
		# TODO: Find where to put them
		sector = $defaultWorld.getSector(0,0)
		loc = astroLocationFromCoords(sector, 50, 50)
	
		player = Player.new(db, id)
		player.location.setSpace(loc)
		return player
	end
end

