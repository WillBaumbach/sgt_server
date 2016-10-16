# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# celestialplanet.rb:
#	Defines a planet in space


require_relative 'redisobject'
require_relative 'celestialbody'
require_relative 'inventory'


# Fixed size piece of the world container 
class CelestialPlanet < CelestialBodyAbstract
	
	# Member Variables
	
	ProbabilityGasPlanet = 0.2
	
	ProbabilityRockHavingAtmosphere = 0.4
	
	# Resource Values : Rock, Always Present
	ResourceRockIronMin = 1.2e6
	ResourceRockIronMax = 8.7e6
	ResourceRockSiMin = 1.0e8
	ResourceRockSiMax = 7.0e8
	
	# Resource Values : Rock, Optional
	ResourceRockProbAl = 0.6
	ResourceRockMaxAl = 7.2e5
	ResourceRockProbCu = 0.7
	ResourceRockMaxCu = 7.5e6
	ResourceRockProbAg = 0.4
	ResourceRockMaxAg = 8e4
	ResourceRockProbPb = 0.7
	ResourceRockMaxPb = 2e4
	
	# Resource Rock/Atmos, Optional
	ResourceRAProbO2 = 0.4
	ResourceRAMaxO2 = 1e5
	ResourceRAProbN2 = 0.9
	ResourceRAMaxN2 = 1e8
	ResourceRAProbH2O = 0.3
	ResourceRAMaxH2O = 1e4
	
	
	# Resource Values : Gas, Always Present
	ResourceGasHMin = 1e9
	ResourceGasHMax = 1e11
	ResourceGasHeMin = 1e6
	ResourceGasHeMax = 1e10
	
	# Resource Values : Gas, Optional
	ResourceGasProbN2 = 0.8
	ResourceGasMaxN2 = 1e6
	ResourceGasProbH20 = 0.1
	ResourceGasMaxH20 = 1e4
	ResourceGasProbNH3 = 0.4
	ResourceGasMaxNH3 = 1e5
	ResourceGasProbO2 = 0.3
	ResourceGasMaxO2 = 1e5
	
	
	# returns inventory associated with resources
	def resources
		Inventory.new(@db, 'sgt-cbody:' + @id + ':resources')
	end
	
	def planetType
		@db.hget('sgt-cbody:' + @id, 'planettype')
	end
	
	# Generates a planet
	def generate()
		inv = newExtractOnlyInventory(@db, 'sgt-cbody:' + @id + ':resources')
	
		# determine planet type
		type = 'gas'
		if rand > ProbabilityGasPlanet
			type = 'rock'
			if rand < ProbabilityRockHavingAtmosphere
				type = 'rockatmos'
			end
		end
		@db.hset('sgt-cbody:' + @id, 'planettype', type)
		
		if type == 'rock' || type == 'rockatmos'
			inv.fill('fe', rand(ResourceRockIronMin...ResourceRockIronMax))
			inv.fill('si', rand(ResourceRockSiMin...ResourceRockSiMax))
			inv.fill('al', rand(0...ResourceRockMaxAl)) if rand < ResourceRockProbAl
			inv.fill('cu', rand(0...ResourceRockMaxCu)) if rand < ResourceRockProbCu
			inv.fill('ag', rand(0...ResourceRockMaxAg)) if rand < ResourceRockProbAg
			inv.fill('pb', rand(0...ResourceRockMaxPb)) if rand < ResourceRockProbPb
			
			if type == 'rockatmos'
				inv.fill('o2', rand(0...ResourceRAMaxO2)) if rand < ResourceRAProbO2
				inv.fill('n2', rand(0...ResourceRAMaxN2)) if rand < ResourceRAProbN2
				inv.fill('h2o', rand(0...ResourceRAMaxH2O)) if rand < ResourceRAProbH2O
			end
		else
			inv.fill('h', rand(ResourceGasHMin...ResourceGasHMax))
			inv.fill('he', rand(ResourceGasHeMin...ResourceGasHeMax))
			inv.fill('nh3', rand(0...ResourceGasMaxNH3)) if rand < ResourceGasProbNH3
			inv.fill('h2o', rand(0...ResourceGasMaxH20)) if rand < ResourceGasProbH20
			inv.fill('o2', rand(0...ResourceGasMaxO2)) if rand < ResourceGasProbO2
			inv.fill('n2', rand(0...ResourceGasMaxN2)) if rand < ResourceGasProbN2
		end
	
		puts 'Planet ' + x.to_s + ' ' + y.to_s
	end
	
end

