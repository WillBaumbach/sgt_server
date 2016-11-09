# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# client.rb:
#	Client communication class

require 'redis'

require_relative 'player'
require_relative 'request'



# Manages communication with a game client
class Client

	# Client constructor takes db ref and websocket connection
	# Called when new connection initiated
	def initialize(ws, world, db)
		@ws = ws
		@world = world
		@listeners = {}
		@id = -1
		@db = db
		
		listen('AUTH', self)
		send('IDENT', 0, '')
		
		listen('VIEWGLOBAL', self)
	end
	
	# Called when client disconnects
	def disconnect()
		puts 'Client Disconnected'
	end
	
	# returns user id
	def id
		@id
	end
	
	# Sends a message to client with given response id
	def send(req, respid, msg)
		toSend = req + " " + respid.to_s + " " + msg
		puts 'SEND: ' + toSend
		@ws.send toSend
	end
	
	def listen(req, callable)
		@listeners[req] = callable
	end
	
	# Called when message recv'd from client
	def message(msg)
		if msg.length > 1024*64 || msg.length < 4
			return
		end
		
		args = msg.split(' ')
		if args.count < 2
			return
		end
		
		reqtext = args[0]
		respid = args[1].to_i
		msg = ""
		
		if args.count > 2
			msg = args[2..-1].join('')
		end
		
		req = Request.new(self, reqtext, respid, msg)
		if ! @listeners.include? reqtext
			puts 'No Listener : ' + reqtext
			return
		end
		
		if @listeners[reqtext].respond_to? 'onRequest'
			@listeners[reqtext].onRequest(req)
		else
			puts @listeners[reqtext].public_methods
			puts 'No onRequest : ' + reqtext
			return
		end
	end
	
	
	# For handling authentication
	def onRequest(req)
		if req.request == 'AUTH'
			uid = req.message
			player = getPlayer(@db, uid)
			player.connected(self)
		else
			req.reply('REPLY', 'Message')
		end
	end
	
end


