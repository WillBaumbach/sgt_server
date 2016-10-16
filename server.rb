#!/usr/bin/env ruby

# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# server.rb:
#	Defines the entry point for the game server.

require 'redis'
require_relative 'world'

# Global reference to the database
$db = Redis.new(:host => "sgt.jeffreysanti.net", :port => 6379, :db => 0)

# Clear all state information
$db.scan_each(match: 'sgt-*') do |keyname|
	$db.del(keyname)
end


# Main method called when server daemon begins
def main
	#loop do
	#	pos = randomLocation(5,5, 2)
	#	puts 'P: ' + pos[0].to_s + ' : ' + pos[1].to_s
	#end


	w = newWorld($db, 'main')
	
	w.getSector(0, 0)
	puts w.sectors
end




main
