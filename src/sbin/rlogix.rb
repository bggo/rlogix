#!/usr/bin/ruby

require "yaml"
require "syslog"
require "bunny"
require "socket"
require "json"

$config_file = "/etc/rlogix/rlogix.conf"
$HOST = Socket.gethostname 
BUFFER = Array.new

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
	puts $max_buffer
end 

def write_amqp()

	Syslog.open("Rlogix", Syslog::LOG_PID, Syslog::LOG_DAEMON | Syslog::LOG_LOCAL3)
	
	ARGF.each do |line|
		
		BUFFER << line

		if BUFFER.length >= $max_buffer

			conn = Bunny.new(:user => $user, :pass => $pass, :host => $server, :logging => true)
			#, :logfile => "/tmp/bunny.log")
			conn.start
			q = conn.queue($queue)
			
			BUFFER.each do |msg|
				q.publish(msg, :persistent => false)
				puts "##################################################"
			end
			conn.stop

			BUFFER.clear
		else
			puts "PUTS TIME ################################"
		end

		BUFFER.each do |pos|
			puts pos
		end
		
		w = BUFFER.length
		puts w

	end

	Syslog.close()
end

load_config()
write_amqp()
