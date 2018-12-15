#!/usr/bin/perl
use strict;
use warnings;


my $buttonUp = 0;
my $buttonDown = 0;
my $buttonOk = 0;
my $line1;
my $line2;
my $line3;
my $line4;

my $initialDelay = 20;

my $unixFinish = time + $initialDelay;


`gpio mode 1 out`;
`gpio mode 4 out`;
`gpio mode 0 in`;
`gpio mode 2 in`;
`gpio mode 3 in`;


`gpio write 1 1`;
`gpio write 4 1`;

# Display IP

my $ip = `ip address list | grep inet | grep -v 127.0.0 | cut -d " " -f 6 | cut -d "/" -f 1`;
my @ip = split (/\n/,$ip);
$ip = $ip[1];
my $mac = $ip[2];


$line1 = "";
$line2 = "My IP: $ip";
$line3 = "";
$line4 = "OK?";


`python lcd.py "$line1" "$line2" "$line3" "$line4"`;



while(1)

	{
		$buttonOk = `gpio read 2`;
		
		if ($buttonOk == 1)
			{	
				goto DATE;
			}
		my $currentUnix = time;
		if ($currentUnix > $unixFinish)
			{
				goto DATE;
			}

	}

DATE:


while(1)
	{

		my $date = `date`;
		my @date = split (/ /,$date);

		my $time = "$date[4] $date[3]";
             
$date[5] = substr( $date[5],0,4);

		$date = "$date[0] $date[1] $date[2] $date[5]";

		$line1= "Time and date";
		$line2 = "$time";
		$line3 = "$date";
		$line4 = "OK?";

		`python lcd.py "$line1" "$line2" "$line3" "$line4"`;

		sleep(1);

		$buttonOk = `gpio read 2`;
		if ($buttonOk == 1)
                        {

                                goto MENU;

                        }

	}
		


MENU:

                $line1= "Functions:";
                $line2 = "Rotator <--";
                $line3 = "Ant Switch";
                $line4 = "Return";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;

		sleep(1);
		
		while(1)
			{
				$buttonUp = `gpio read 0`;
				$buttonOk = `gpio read 2`;
				$buttonDown = `gpio read 3`;

				if ($buttonUp == 1)
					{
				
						

					}

				if ($buttonOk == 1)
					{
					
						goto MENUCW;
					}

				if ($buttonDown == 1)
					{
						goto MENUANTSWITCH;
					} 
			}

MENUCW:

                $line1= "ANT Azimuth: 234";
                $line2 = "Turn CW <--";
                $line3 = "Turn CCW";
                $line4 = "RETURN";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;
		sleep(1);

		while(1)
			{

                		$buttonUp = `gpio read 0`;
                		$buttonOk = `gpio read 2`;
                		$buttonDown = `gpio read 3`;

			
                		if ($buttonOk == 1)
                               	 	{
	
        	                     		goto CW;           

	                                }

				if ($buttonDown == 1)
                                {
                                        goto MENUCCW;
							
                                }

			}

MENUCCW:

 		$line1= "Ant Azimuth:  234";
                $line2 = "Turn CW ";
                $line3 = "Turn CCW <--";
                $line4 = "RETURN";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;
		sleep(1);
		
		while(1)
			{                
				$buttonUp = `gpio read 0`;
                		$buttonOk = `gpio read 2`;
                		$buttonDown = `gpio read 3`;

		
				if ($buttonUp == 1)
                                	{

                        	                goto MENUCW;
                	                }


		                if ($buttonOk == 1)
                                	{

                                        	goto CCW;

                                	}

                		if ($buttonDown == 1)
                                	{
                                        	goto RETURN;
                                	}
			}
                               

CCW:

		$line1= "Ant Azimut:234";
                $line2 = "Turning CCW";
                $line3 = ".";
                $line4 = "OK to STOP?";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;
		`gpio write 1 0`;
                sleep(1);
		
                while(1)
                        {
                   		$line1= "Ant Azimut:234";
                                $line3 = "..";
                                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;

		
			        $buttonUp = `gpio read 0`;
                                $buttonOk = `gpio read 2`;
                                $buttonDown = `gpio read 3`;


                                if ($buttonUp == 1)
                                        {

                                                
                                        }


                                if ($buttonOk == 1)
                                        {

                                               `gpio write 1 1`;
 						goto MENUCCW;

                                        }

                                if ($buttonDown == 1)
                                        {
                                                
                                        }
                        }



CW:

                $line1= "Ant Azimut:234";
                $line2 = "Turning CW";
                $line3 = ".";
                $line4 = "OK to STOP?";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;
		`gpio write 4 0`;
                sleep(1);

                while(1)
                        {
                                

				$line1= "Ant Azimut:234";
				$line3 = "..";
				`python lcd.py "$line1" "$line2" "$line3" "$line4"`;



				$buttonUp = `gpio read 0`;
                                $buttonOk = `gpio read 2`;
                                $buttonDown = `gpio read 3`;


                                if ($buttonUp == 1)
                                        {


                                        }


                                if ($buttonOk == 1)
                                        {

                                                `gpio write 4 1`;
						goto MENUCW;

                                        }

                                if ($buttonDown == 1)
                                        {

                                        }
			}






MENUANTSWITCH:

                $line1= "Functions:";
                $line2 = "Rotator";
                $line3 = "Ant Switch <--";
                $line4 = "Return";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;

                sleep(1);

                while(1)
                        {
                                $buttonUp = `gpio read 0`;
                                $buttonOk = `gpio read 2`;
                                $buttonDown = `gpio read 3`;

                                if ($buttonUp == 1)
                                        {

                                                goto MENU;

                                        }

                                if ($buttonOk == 1)
                                        {

                                                goto ROTATOR;
                                        }

                                if ($buttonDown == 1)
                                        {
                                                goto RETURN;
                                        }
                        }











RETURN:

 		$line1= "Return";
                $line2 = "to Clock";
                $line3 = "and Date";
                $line4 = "OK?";

                `python lcd.py "$line1" "$line2" "$line3" "$line4"`;

                sleep(1);

                while(1)
                        {
                                $buttonUp = `gpio read 0`;
                                $buttonOk = `gpio read 2`;
                                $buttonDown = `gpio read 3`;

                                if ($buttonUp == 1)
                                        {



                                        }

                                if ($buttonOk == 1)
                                        {

                                                goto DATE;
                                        }

                                if ($buttonDown == 1)
                                        {
                                               
                                        }
                        }







sleep(1);

