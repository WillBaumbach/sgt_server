#!/usr/bin/env ruby

# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# server.rb:
#	Defines the entry point for the game server.

require 'redis'
require 'em-websocket'

require_relative 'world'
require_relative 'client'

# Global reference to the database
$db = Redis.new(:host => "sgt.jeffreysanti.net", :port => 6379, :db => 0)

# Clear all state information
def resetMap
	db.scan_each(match: 'sgt-*') do |keyname|
		$db.del(keyname)
	end
end


$defaultWorld = nil


# Main method called when server daemon begins
def main
	#loop do
	#	pos = randomLocation(5,5, 2)
	#	puts 'P: ' + pos[0].to_s + ' : ' + pos[1].to_s
	#end

	$defaultWorld = newWorld($db, 'main')
	
	EM.run {
		EM::WebSocket.run(:host => "0.0.0.0", :port => 1111, :secure => false) do |ws|
			client = nil

			ws.onopen { |handshake|
				client = Client.new(ws, $defaultWorld, $db)
			}

			ws.onclose {
				client.disconnect unless client == nil
			}

			ws.onmessage { |msg|
				client.message msg
			}
		end
	}
	
	w.getSector(0, 0)
	puts w.sectors
end




main
