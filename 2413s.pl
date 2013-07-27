#!/usr/bin/perl

use Device::SerialPort;

my $PORT = "/dev/ttyS0";

my $PortObj = Device::SerialPort->new($PORT);
$PortObj->databits(8);
$PortObj->baudrate(19200);
$PortObj->parity("none");
$PortObj->stopbits(1);
$PortObj->write_settings || undef $PortObj;

#---
my $line = pack 'H4',"0260";
$PortObj->write($line);

my $STALL_DEFAULT=2; # how many seconds to wait for new input 
my $timeout=$STALL_DEFAULT;
 
$PortObj->read_char_time(0);     # don't wait for each character
$PortObj->read_const_time(100); # 1 second per unfulfilled "read" call
 
 my @myArray;
 my $chars=0;
 my $buffer="";
 while ( 1) { #$timeout>0) {
        my ($count,$saw)=$PortObj->read(255); # will read _up to_ 255 chars
        if ($count > 0) {
				print "..";
                $chars+=$count;
                $buffer.=$saw;
                # Check here to see if what we want is in the $buffer
                # say "last" if we find it
				@myArray=unpack('C*', $saw);
				foreach my $c (@myArray) {
					print (sprintf ("%lx", $c)."");
				}
				print ("--- $count \n");
				#print "$myStringHex";

        }
        else {
                $timeout--;
        }
 }

 if ($timeout==0) {
        die "Waited $STALL_DEFAULT seconds and never saw what I wanted\n";
 }
