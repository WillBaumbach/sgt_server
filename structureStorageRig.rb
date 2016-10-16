# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# structureStorgageRig.rb:
#	Defines a storage structure attached to a planet


require_relative 'structure'
require_relative 'celestialbody'
require_relative 'unit'


# Storage structure attached to a planet
class StructureStorageRig < StructureAbstract
	
	# Member Variables	
	
end

# Creates a new storage structure which is then anchored to a celestial body
def newStructureStorageRig(db, cb)
	newId = newUUID(db)
	@db.hset('sgt-structure:' + newId, 'type', 'storage')
	
	struct = getStructure(db, newId)
	cb.anchorStructure(struct)
	
	
	# Man the rig -> Just testing TODO: Remove
	u = newUnit(db, 'human')
	struct.stationUnit(u)
	
	
	struct
end



