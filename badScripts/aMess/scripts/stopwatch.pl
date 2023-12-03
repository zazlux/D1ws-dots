#!/usr/bin/env perl
#Program to  implement a simple stopwatch using Perl
use strict;
use warnings;

print "Press Enter to start the stopwatch.\n";
<>;
my $start_time = time;
print "Stopwatch started. Press Enter to stop.\n";
<>;
my $end_time = time;
my $elapsed_time = $end_time - $start_time;
printf "Elapsed time: %.2f seconds\n", $elapsed_time;

#This program uses the  <>  operator to read input from the user and the  time  function to get the
#current time in seconds. The  $start_time  variable stores the time when the user presses Enter to
#start the stopwatch and the $end_time variable stores the time when the user presses Enter to stop
#the   stopwatch.   The  $elapsed_time  variable   stores   the   difference   between  $end_time  and
#$start_time.  Finally, the  print  function  is   used   to  display  the   elapsed   time  to   the   user   with  a
#precision of 2 decimal places.
