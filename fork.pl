
#!/usr/bin/perl
use strict;
use warnings;

# Proper way to fork with proper termination of child process and no zambies

my $childPid = fork();
if( $childPid == 0 )
        {

                while(1)
                        {
                                print "This is CHILD $childPid\n";
                                sleep(1);
                        }
        }


while(1)
        {
                print "This is PARENT Child PID: $childPid\n";
                sleep(1);
                my $input = <STDIN>;
                if ($input == 1)
                        {

                                $SIG{CHLD} = sub { wait };
                                 `sudo kill $childPid`;
                        }

        }

