#!/usr/bin/env ruby

# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# server.rb:
#	Defines the entry point for the game server.

require 'redis'
require_relative 'world'

# Global reference to the database
$db = Redis.new(:host => "localhost", :port => 6379, :db => 0)

# Main method called when server daemon begins
def main
	w = World.new($db, 'world/0')
	
	w.generateSector('sector/1', 0, 0)
	puts w.sectors
end




main
