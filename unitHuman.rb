# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# unit.rb:
#	A human unit


require_relative 'unit'


# A human unit
class UnitHuman < UnitAbstract
	
	# Member Variables
	
	
	# returns a list of all skills this human has
	def skills
		['piloting', 'building']
	end
	
end






