
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# unit.rb:
#	An employable entity within the game


require_relative 'redisobject'
require_relative 'job'


class UnitLocation
	def initialize(db, id)
		@id = id
		@db = db
	end
	
	# internal representation
	def rawString
		s = @db.hget('sgt-unit:'+@id, 'loc')
		if s == nil || s == ''
			return 'a:0:0,0'
		end
		return s
	end
	
	# internal representation
	def setRawString(str)
		@db.hset('sgt-unit:'+@id, 'loc', str)
	end
	
	# returns if the unit is in space
	def space?
		rawString.start_with? 'a'
	end
	
	# returns an astrolocation reference
	def space
		AstroLocation.new(@db, rawString)
	end
	
	# sets location as an astrolocation
	def setSpace(astro)
		setRawString(astro.to_s)
	end
	
	# returns if the unit is in a structure
	def structure?
		rawString.start_with? 's'
	end
	
	# returns structure unit inside
	def structure
		args = rawString.split(':')
		sid = args[1]
		getStructure(@db, sid)
	end
	
	# sets unit location inside structure
	def setStructure(structure)
		setRawString('s:' + structure.id)
	end
	
	
end


# A generic entity within the game
class UnitAbstract < RedisObject
	
	# Member Variables
	
	# Classification of unit (human, robot, etc)
	def type
		@db.hget('sgt-unit:'+@id, 'type')
	end
	
	# Job currently working on (or nil)
	def job
		jid = @db.hget('sgt-unit:'+@id, 'job')
		return nil if jid == nil
		getJob(@db, jid)
	end
	
	# returns a location reference for where this unit is
	def location
		UnitLocation.new(@db, @id)
	end
	
	# Delegates this unit to work this job (called by job)
	def startWorkingJob(job)
		@db.hset('sgt-unit:'+@id, 'job', job.id)
	end
	
	# removes unit from job (called by job)
	def quitWorkingJob
		@db.hdel('sgt-unit:'+@id, 'job')
	end
	
	# returns a list of all skills this unit has
	def skills
		[]
	end
	
end


require_relative 'unitHuman'

# Returns the correct class of unit based on the db type
def getUnit(db, uid)
	unit = UnitAbstract.new(db, uid)
	type = unit.type
	
	if type == 'human'
		return UnitHuman.new(db, uid)
	end
	
	unit
end

def newUnit(db, type)
	newId = newUUID(db)
	@db.hset('sgt-unit:' + newId, 'type', type)
	
	getUnit(db, newId)
end



