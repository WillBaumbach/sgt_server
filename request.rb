# SpaceGameThing project originally developed for CSE 2102
# Copyright 2016: Will Baumbach and Jeffrey Santi
# 
# request.rb:
#	Client communication request

require 'redis'
require 'json'

# Container for a request from a client
class Request

	# Member Variables
	# @reqtext
	# @respid
	# @msg
	# @client
	

	# Request Constructor
	def initialize(client, reqtext, respid, msg)
		@reqtext = reqtext
		@respid = respid
		@msg = msg
		@client = client
	end
	
	# Returns the message
	def message
		@msg
	end
	
	def json
		begin
			return JSON.parse(@msg)
		rescue
			return {}
		end
	end
	
	# returns request type
	def request
		@reqtext
	end
	
	# replies with new request req and message msg
	def reply(req, msg)
		@client.send(req, @respid, msg)
	end
	
end


