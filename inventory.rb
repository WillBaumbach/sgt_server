# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# inventory.rb:
#	Container for resources




# Container for resources
class Inventory
	
	# Member Variables
	# @db
	# key
	
	SpecialKeys = ['<CAP>', '<USED>', '<DRAWONLY>']
	
	# inventory constructor
	def initialize(db, key)
		@db = db
		@key = key
	end
	
	# returns hash of all resource-quantity pairs
	def resources
		ret = {}
		@db.hgetall(key).each do |res, quant|
			unless SpecialKeys.include? res
				ret[res] = quant
			end
		end
		ret
	end

	# returns whether capacity is limited
	def limitedCapacity?
		@db.hexists(@key, '<CAP>')
	end
	
	# returns max capacity
	def capacity
		@db.hget(@key, '<CAP>').to_i
	end
	
	# returns capatity used
	def inUse
		@db.hget(@key, '<USED>')
	end
	
	# returns whether inventory can only be drawn from (ie: planet)
	def drawOnly?
		@db.hexists(@key, '<DRAWONLY>')
	end
	
	# returns amount of specified resource (or zero if none)
	def resource(res)
		ret = @db.hget(@key, res)
		return 0 if ret == nil
		ret.to_i
	end
	
	# fills resource into inventory
	def fill(res, amount)
		return false if drawOnly?
		return false if limitedCapacity? && inUse + amount > capacity
		newAmount = resource(res) + amount
		newTotalUse = inUse + amount
		@db.hset(@key, res, newAmount)
		@db.hset(@key, '<USED>', newTotalUse)
		true
	end
	
	def draw(res, amount)
		newAmount = resource(res) - amount
		return false if newAmount < 0
		newTotalUse = inUse - amount
		@db.hset(@key, res, newAmount)
		@db.hset(@key, '<USED>', newTotalUse)
	end

	
end


def newLimitedInventory(db, key, cap)
	db.del(key)
	inv = Inventory.new(db, key)
	@db.hset(key, '<CAP>', cap)
	inv
end

def newExtractOnlyInventory(db, key)
	db.del(key)
	inv = Inventory.new(db, key)
	@db.hset(key, '<DRAWONLY>', 1)
	inv
end
