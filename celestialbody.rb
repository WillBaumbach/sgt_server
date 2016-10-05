
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# celestialbody.rb:
#	Defines a natural object in space (planet, star, astroid, etc)


require_relative 'redisobject'
require_relative 'solarsystem'


# Fixed size piece of the world container 
class CelestialBody < RedisObject
	
	# Member Variables
	
	
	# Generates new (absract)
	def generate()
	
	end
	
end

# class Planet : CelestialBody


def newCelestialBody(db, solarsystem, x, y, type)

# return Planet.new(db, id) or Star
end
