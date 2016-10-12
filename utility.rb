
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# utility.rb:
#	Miscellaneous methods used by all classes


# returns a new id unique from any other returned by this method
def newUUID(db)
	db.incr('sgt-uuid').to_s
end



# Generates a random cartesian location centered around cx, cy within distance r
def randomLocation(cx, cy, rad)
	theta = Random.rand(0...2*Math::PI)
	r = Random.rand(0...rad)
	
	x = cx + r*Math.cos(theta)
	y = cy + r*Math.sin(theta)
	[x, y]
end
