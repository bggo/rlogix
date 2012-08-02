# Rlogix #

Recives data from a pipe and publish to a AMPQ Server.

## What is done ##
 * Recive a MSG fron a Pipe ;
 * Send the message to a AMQP server;
 * Bufferize X messages until send (Avoid open lots of connections)

## TODO ##
 * Test it in ErrorLog and CustonLog in Apache2;
 * Make every message be stored by local syslog;
 * Test another ways of inputing messages

