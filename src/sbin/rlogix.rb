#!/usr/bin/ruby

require "yaml"
require "syslog"
require "bunny"

$config_file = "/etc/rlogix/rlogix.conf"
$MSG = ARGF.read

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
end 

def write_amqp()

	Syslog.open("Rlogix", Syslog::LOG_PID, Syslog::LOG_DAEMON | Syslog::LOG_LOCAL3)
	
	conn = Bunny.new(:user => $user, :pass => $pass, :host => $server)
	conn.start
	q = conn.queue($queue)
	q.publish($MSG)
	conn.stop

	Syslog.close()
end

load_config()
write_amqp()