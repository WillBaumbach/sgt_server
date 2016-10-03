
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# job.rb:
#	Tasks held by units


require_relative 'redisobject'
require_relative 'unit'


# A generic container for in-progress jobs by units
class JobAbstract < RedisObject
	
	# Member Variables
	
	# returns a list of all units working on this job
	def units
		ret = []
		@db.smembers('sgt-job:' + @id + ':units').each do |uid|
			ret.push(getUnit(@db, uid))
		end
		ret
	end
	
	# internal job type
	def type
		@db.hget('sgt-job:'+@id, 'type')
	end
	
	# player who initiated this work
	def master
		# TODO: Convert to player object
		@db.hget('sgt-job:'+@id, 'master')
	end
	
	# returns a list of all skills needed for units working job
	def skillsNeeded
		[]
	end
	
	# employs a unit if they have the skills needed and are free
	def employUnit(unit)
		return false if unit.job != nil
		
		unitSkills = unit.skills
		skillsNeeded.each do |skill|
			if ! unitSkills.include? skill
				return false
			end
		end
		
		@db.sadd('sgt-job:' + @id + ':units', unit.id)
		unit.startWorkingJob self
		true
	end
	
	# removes a unit from employment in this job
	def unemployUnit(unit)
		return false if unit.job == nil
		return false if unit.job.id == id
		@db.srem('sgt-job:' + @id + ':units', unit.id)
		unit.quitWorkingJob
	end
	
	# Frees all units and closes the job
	def endJob
		units.each do |unit|
			unemployUnit unit
		end
		
		# TODO: Remove job from it's queue
		
		@db.del('sgt-job:' + @id + ':units')
		@db.del('sgt-job:'+@id)
	end
	
end



# Returns the correct class of job based on the db type
def getJob(db, jid)
	job = JobAbstract.new(db, jid)
	type = job.type
	
	#if type == 'build'
	#	return JobBuild.new(db, jid)
	#end
	
	job
end
