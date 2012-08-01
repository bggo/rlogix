#!/usr/bin/ruby

require "rubygems"
require "amqp"
require "fileutils"
require "yaml"
require "socket"

$config_file = "/etc/rlogix/rlogix.conf"
$hostname = Socket.gethostname
$severity = ['emerg', 'alert', 'crit', 'err', 'warn', 'notice', 'info', 'debug']
$facility = ['kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr',
            'news', 'uucp', 'cron', 'authpriv', 'ftp', 'ntp', 'audit',
            'alert', 'at', 'local0', 'local1', 'local2', 'local3',
            'local4', 'local5', 'local6', 'local7']

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
	$debug = globalConf['debug']
	$q = globalConf['queue']


end 

def write_amqp()

	EventMachine.run do
  		connection = AMQP.connect(:host => $server)
  		puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  		channel  = AMQP::Channel.new(connection)
  		queue    = channel.queue($q, :auto_delete => false)
  		exchange = channel.direct("")

  	queue.subscribe do |payload|
    	puts "Received a message: #{payload}. Disconnecting..."
    connection.close { EventMachine.stop }
  	end

  	exchange.publish "Hello, world!", :routing_key => queue.name
end

end

load_config()
write_amqp()

	#puts $server
	#puts $debug
	#puts $hostname
	#puts $severity
	#puts $facility
	#puts $q

#def main()
	
#end

