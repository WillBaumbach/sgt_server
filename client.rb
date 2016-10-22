# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# client.rb:
#	Client communication class

require 'redis'

require_relative 'world'



# Manages communication with a game client
class Client

	# Client constructor takes db ref and websocket connection
	# Called when new connection initiated
	def initialize(ws, world)
		@ws = ws
		@world = world
		
		send 'IDENT'
	end
	
	# Called when client disconnects
	def disconnect()
		puts 'Client Disconnected'
	end
	
	# Sends a messgae to client
	def send(msg)
		puts 'SEND: ' + msg
		@ws.send msg
	end
	
	# Called when message recv'd from client
	def message(msg)
		if msg.length > 1024
			puts 'Message too long'
			return
		end
		puts 'Message ' + msg
		
		
	end
	
end


