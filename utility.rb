
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# utility.rb:
#	Miscellaneous methods used by all classes


# returns a new id unique from any other returned by this method
def newUUID(db)
	db.incr('sgt-uuid').to_s
end


