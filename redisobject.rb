
# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# redisobject.rb:
#	Base class for all objects which model part of the redis kv store.



# Base class for all objects which model part of the redis kv store.
class RedisObject
	
	# Member Variables
	# @id : Database id
	# @db : Redis datastore reference

	# Permentantly stores db reference and corresponding db id
	def initialize(db, id)
		@id = id
		@db = db
	end

	# returns internal database id for this object
	def id
		@id
	end
	
end

