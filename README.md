# Rlogix #

Recives data from a pipe and publish to a AMPQ Server.

## What is done ##
 * Recive a MSG fron a Pipe ;
 * Send the message to a AMQP server;
 * Bufferize X messages until send (Avoid open lots of connections)
 * Tested with CustonLog(apache2) and so long working. =D

## TODO ##
 * Create two treads to run the actions. One action just recive from apache and store in the buffer, another, send to AMPQ
 * Test it in ErrorLog Apache2;
 * Adapt code to log in syslog too;
 * Test another ways of inputing messages;

