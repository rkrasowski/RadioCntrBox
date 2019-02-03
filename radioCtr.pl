#!/usr/bin/perl
use strict;
use warnings;

######################### radioController.pl ############################
#									#
#		Controll Flex Radio, Rotator, Ant switch		#
#									#
############################# 2019 ######################################
# RAspberry Pi GPIO Pins:
# Up   		-> 0
# OK   		-> 2
# Down 		-> 3
# Flex ON/OFF 	-> 5
# Rotator CW	-> 1
# Rotator CCW	-> 4

my $buttonUp = 0;
my $buttonDown = 0;
my $buttonOk = 0;
my $line1;
my $line2;
my $line3;
my $line4;
my $CCWlimit = 3;
my $CWlimit = 359;


my $file = "/home/pi/HamRadio/RadioCntrBox/temp.txt";
my $flexONOFF = 0;			# Indicate Flex On->1 Off->0
my $azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
my $initialDelay = 3;
my $unixFinish = time + $initialDelay;

# Resets pins in Raspberry Pi

`gpio mode 1 out`;
`gpio mode 4 out`;
`gpio mode 5 out`;
`gpio mode 0 in`;
`gpio mode 2 in`;
`gpio mode 3 in`;

`gpio write 1 1`;
`gpio write 4 1`;
`gpio write 5 1`;

# Reset temp.txt file  - current data

writeFile(0,120);

# Display IP

my $ip = `ip address list | grep inet | grep -v 127.0.0 | cut -d " " -f 6 | cut -d "/" -f 1`;
my @ip = split (/\n/,$ip);
$ip = $ip[1];
my $mac = $ip[2];

$line1 = "";
$line2 = "My IP: $ip";
$line3 = "";
$line4 = "OK?";

`python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

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


		my $date = `date`;
		my @date = split (/ /,$date);

		my @hrMin = split (/:/,$date[4]);
		my $hrMIn;
		my $time = "$hrMin[0]:$hrMin[1] $date[5]";             



		$date[6] = substr( $date[6],0,4);

		$date = "$date[0] $date[1] $date[3] $date[6]";

		$line1= "Time and date";
		$line2 = "$time";
		$line3 = "$date";
		$line4 = "OK for Menu";

		`python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;


		my $clockTime = `date +%s`;
		my $clockTimeStep = $clockTime + 60;

	while(1)
		{
		
			$clockTime = `date +%s`;	
			if ($clockTime >= $clockTimeStep)
				{
					goto DATE;
				}



			$buttonOk = `gpio read 2`;
			if ($buttonOk == 1)
                	        {
                        	        goto MENU;
                        	}
		}
		


MENU:

                $line1= "Functions:";
                $line2 = "Radio ON/OFF <--";
                $line3 = "Rotator";
                $line4 = "Audio Recording";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

		
		
		while(1)
			{
				$buttonUp = `gpio read 0`;
				$buttonOk = `gpio read 2`;
				$buttonDown = `gpio read 3`;
			

				if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
					{

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
					
										goto FLEXONOFF;
									}

								if ($buttonDown == 1)
									{
										goto ROTATOR;
									} 
							}
					}
			}





FLEXONOFF:

		readFile();

		if ($flexONOFF == 0)
			{
			
  				$line1= "FLEX is OFF";
                		$line2 = "Turn it ON?";
                		$line3 = "OK?";
                		$line4 = "DOWN to  Exit";

                		`python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;
		
			while(1)
				{
                		 	

					$buttonUp = `gpio read 0`;
                                        $buttonOk = `gpio read 2`;
                                        $buttonDown = `gpio read 3`;

					if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                        	{

                                                	while(1)
                                                        	{
                                					$buttonUp = `gpio read 0`;
                                					$buttonOk = `gpio read 2`;
                                					$buttonDown = `gpio read 3`;

		                                			if ($buttonOk == 1)
                		                        			{
											writeFile(1,$azimuth);
											`gpio write 5 0`;
        		                                        			goto MENU;
                        		                			}

                                					if ($buttonDown == 1)
                                        					{
                                                					goto MENU;
                                        					}
                        					}
						}

				}
			}

 		if ($flexONOFF == 1)
                        {

                                $line1= "FLEX is ON";
                                $line2 = "Turn it OFF?";
                                $line3 = "OK?";
                                $line4 = "DOWN to  Exit";
                                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;

                                while(1)
                                        {
                                                $buttonUp = `gpio read 0`;
                                                $buttonOk = `gpio read 2`;
                                                $buttonDown = `gpio read 3`;

						  if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                	{
                                                       		 while(1)
                                                                	{
                                                                        	$buttonUp = `gpio read 0`;
                                                                        	$buttonOk = `gpio read 2`;
                                                                        	$buttonDown = `gpio read 3`;

                                                				if ($buttonOk == 1)
                                                        				{
												writeFile(0,$azimuth);
												`gpio write 5 1`;
                                                                				goto MENU;
                                                        				}

                                                				if ($buttonDown == 1)
                                                        				{
                                                                				goto MENU;
                                                        				}
                                        				}
							}
  		                      }
			}




ROTATOR:


		$line1= "Functions:";
                $line2 = "Radio ON/OFF ";
                $line3 = "Rotator <--";
                $line4 = "Audio Recording";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

                while(1)
                        {
				readButtons();
  				if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                {

                                                        while(1)
                                                                {
                                                                        readButtons();


                                					if ($buttonUp == 1)
                                        					{
											goto MENU;
                                        					}

                                					if ($buttonOk == 1)
                                        					{
                                                					goto MENUCW;
                                        					}

                                					if ($buttonDown == 1)
                                        					{
                                                					goto AUDIO;
                                        					}
                        					}
						}
		}



MENUCCW:
		$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
                $azimuth = $azimuth / 50.8;
                $azimuth = sprintf ("%d", $azimuth);

                $line1= "ANT Azimuth: $azimuth";
                $line2 = "Turn CCW <--";
                $line3 = "Turn CW";
                $line4 = "RETURN";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;
		
		while(1)
			{
		 		readButtons();
                       		if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                {

							while(1)
								{
									readButtons();

					                		if ($buttonOk == 1)
                               	 						{
        	                     							goto CCW;           
	                                					}
									if ($buttonDown == 1)
                                						{
                                        						goto MENUCW;	
                                						}
								}
						}
			}

MENUCW:

		$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
                $azimuth = $azimuth / 50.8;
                $azimuth = sprintf ("%d", $azimuth);

 		$line1= "Ant Azimuth: $azimuth";
                $line2 = "Turn CCW ";
                $line3 = "Turn CW <--";
                $line4 = "RETURN";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;
		
		
		 while(1)
                        {
                                readButtons();
                                if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                {

                                                        while(1)
                                                                {
                                                                        readButtons();		
									if ($buttonUp == 1)
                                						{
                        	                					goto MENUCCW;
                	                					}	
		                					if ($buttonOk == 1)
                                						{
                                        						goto CW;
                                						}
                							if ($buttonDown == 1)
                                						{
                                        						goto RETURN;
                                						}
								}
						}
			}
                               

CW:


 		$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
                $azimuth = $azimuth / 50.8;
                $azimuth = sprintf ("%d", $azimuth);


		$line1= "Ant Azimuth: $azimuth";
                $line2 = "Turning CW";
                $line3 = ".";
                $line4 = "OK to STOP?";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;
		`gpio write 1 0`;                
		
                while(1)
                        {
				readButtons();
                                if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
					{
						while(1)
							{
								$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
								$azimuth = $azimuth / 50.8;
								$azimuth = sprintf ("%d", $azimuth);
                   		
								$line1= "Ant Azimuth: $azimuth";
                                				$line3 = "..";
                                				`python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;
				
								if ($azimuth >= $CWlimit)		# SAfety limit for turning azimuth)
									{
										`gpio write 1 1`;						
										goto MENUCCW;
									}

                		                		readButtons();                         
                                                         
                                				if ($buttonOk == 1)
                                        				{
                                               					`gpio write 1 1`;
 										goto MENUCW;
                                        				}
                        				}
					}
			}
			



CCW:

 		$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
                $azimuth = $azimuth / 50.8;
                $azimuth = sprintf ("%d", $azimuth);
                
		$line1= "Ant Azimut: $azimuth";
                $line2 = "Turning CCW";
                $line3 = ".";
                $line4 = "OK to STOP?";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;
		`gpio write 4 0`;
               

                while(1)
                        {
                                readButtons();
                                if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
					{
						while(1)
							{
								$azimuth = `python /home/pi/HamRadio/RadioCntrBox/azimuth.py`;
                                				$azimuth = $azimuth / 50.8;
                                				$azimuth = sprintf ("%d", $azimuth);

				                                $line1= "Ant Azimut: $azimuth";
								$line3 = "..";
								`python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;
								
								readButtons();
								if ($azimuth <= $CCWlimit)
                                        				{
                                                				`gpio write 4 1`;
										goto MENUCW;
                                        				}

				                                if ($buttonOk == 1)
                                				        {
                                                				`gpio write 4 1`;
										goto MENUCCW;
                                        				}
							}
					}
			}






AUDIO:

                $line1= "Functions:";
                $line2 = "Rotator";
                $line3 = "Audio Record <--";
                $line4 = "Return";
                `python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

                while(1)
                        {
                                readButtons();
                                if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                {

                                                        while(1)
                                                                {
                                                                        readButtons();
                                					if ($buttonUp == 1)
                                        					{
                                                					goto ROTATOR;
                                        					}
                                					if ($buttonOk == 1)
                                        					{
                                                					goto AUDIOMENU;
                                        					}
                                					if ($buttonDown == 1)
                                        					{
                                                					goto RETURN;
                                        					}
                        					}
						}
			}





AUDIOMENU:


		$line1= "Audio Recording:";
                $line2 = "UP to go back";
                $line3 = "OK to record";
                $line4 = "DOWN to Return";
                `python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

                while(1)
                        {
                                readButtons();
                                if($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
                                                {
                                                        while(1)
                                                                {
                                                                        readButtons();
                                					if ($buttonUp == 1)
                                        					{
                                                					goto AUDIO;
                                        					}
                                					if ($buttonOk == 1)
                                        					{
                                                					goto RECORDING;
                                        					}
                                					if ($buttonDown == 1)
                                        					{
                                                					goto RETURN;
                                        					}
                        					}
						}
			}





RECORDING:
		$line1= "RECORDING:";
                $line2 = "Time:";
                $line3 = "0 min 0 sec";
                $line4 = "Ok to stop";
                `python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;

		 while(1)
                        {
                                readButtons();
                                if ($buttonUp == 0 and $buttonOk == 0 and $buttonDown == 0)
					{
					while(1)
						{
							local $SIG{CHLD} = "IGNORE";
							my $recFileName = fileName();
							my $arecordPID;
							my $childPid = fork();

							if( $childPid == 0 )
        							{
									`sudo arecord -D hw:1,0 -f cd /var/www/html/recordings/$recFileName.wav -c 1`;		# Child process RECORDING
        							}

							my $totalSec = 0;

                					while(1)
                        					{
									$totalSec = $totalSec + 1;
									my $min;
									my $hrs;
									my $sec;

									$min = $totalSec / 60;
									$min =~ s/\.\d+$//;

									if ($totalSec <60)
        									{
                									$sec = $totalSec;
        									}
									else
        									{
                									$sec = $totalSec -($min * 60)
        									}

									my $displayRecTime = "$min min $sec sec";

									sleep(1);
									$line1= "RECORDING:";
                							$line2 = "Time: ";
                							$line3 = "$displayRecTime";
                							$line4 = "OK to stop";

                							`python /home/pi/HamRadio/RadioCntrBox/lcd.py "$line1" "$line2" "$line3" "$line4"`;
									
							
									readButtons();
                                					if ($buttonOk == 1)
                                        					{
											$arecordPID = `pgrep -f arecord`;
                                                                
											my @arecordPID = split(/\n/,$arecordPID);

											`sudo kill $arecordPID[1]`;
										

								 			#$SIG{CHLD} = sub { wait };								
				                                			`sudo kill $childPid`;
											goto AUDIOMENU;
                              		          				}
								}
                              
					}	}
		
                        }











MENUANTSWITCH:

                $line1= "Functions:";
                $line2 = "Rotator";
                $line3 = "Ant Switch <--";
                $line4 = "Return";

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;

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

                `python /home/pi/HamRadio/RadioCntrBox/lcd.py  "$line1" "$line2" "$line3" "$line4"`;

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



############################ Subroutines ################################################



sub readFile
        {

                open( my $fh, '<', $file ) or die "Can't open $file: $!";

                my $data;
                my $line;
                while (my $line = <$fh>)
                        {
                                $data .=$line;
                        }

                my @line = split(/ /,$data);
                $flexONOFF = $line[0];
                $azimuth = $line[1];
                close $fh;

        }

sub writeFile

        {
                my $flexONOFFWrite = shift;
                my $azimuthWrite = shift;
                open( my $fh, '>', $file ) or die "Can't open $file: $!";
                print $fh "$flexONOFFWrite $azimuthWrite";
                close $fh;
        }


sub fileName
        {
                my $date = `date`;
                my @date = split (/ /,$date);
                chomp$date[6];

                my @HrMin = split(/:/,$date[4]);
                my $HrMin;


                my $fileName = "$date[3]-$date[1]-$date[6]_$HrMin[0]_$HrMin[1]_$HrMin[2]";
                return $fileName;
        }

sub readButtons
	{
		$buttonUp = `gpio read 0`;
                $buttonOk = `gpio read 2`;
                $buttonDown = `gpio read 3`;
	}
