#!/usr/bin/ruby

require "yaml"
require "bunny"
require "thread"

$config_file = "/etc/rlogix/rlogix.conf"
BUFFER = Array.new
mutex = Mutex.new

def load_config()
	
	if File.exists?($config_file)
		loadedConf = YAML.load_file $config_file
	else
		puts $config_file + " not found!!!"
		raise "Something went wrong . . ."
		exit 1
	end
	
	globalConf = loadedConf.fetch('global')
	$server = globalConf['server']
	$queue = globalConf['queue']
	$debug = globalConf['debug']
	$port = globalConf['port']
	$user = globalConf['user']
	$pass = globalConf['pass']
	$vhost = globalConf['vhost']
	$max_buffer = globalConf['max_buffer'].to_i
end 

load_config()

collector = Thread.new do
	mutex.synchronize do

	    	ARGF.each do |line|
	            BUFFER << line
	    	end

	end

end

sender = Thread.new do
	mutex.synchronize do


		#if ! a.empty?
					
		if BUFFER.length >= $max_buffer
		
			conn = Bunny.new(:user => $user, :pass => $pass, :host => $server, :logging => true)
			#, :logfile => "/tmp/bunny.log")
			conn.start
			q = conn.queue($queue)
		
			BUFFER.each do |msg|
				q.publish(msg, :persistent => false)
				puts "msg"
			end
			conn.stop
			BUFFER.clear

		else
			puts "Não atingiu #{$max_buffer} - #{BUFFER.length}"
		end

 		
  		
	end
end
mutex.lock

#r = collector.alive?
#t = sender.alive?
#puts r
#puts t
