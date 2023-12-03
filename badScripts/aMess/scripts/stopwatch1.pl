#!/usr/bin/env perl
use strict;
use warnings;
use Term::ANSIScreen qw(cls);
my $HH=0;
my $MM=0;
my $SS=0;
my $MSS=1;



for ($i=1;$i<=100000;$i++)
{
system "cls";
print "\n\n\n\n";
print"                  STOP WATCH\n";
print"\n\n";
print"            =============================\n";
print "\t\t\t\t";


if($MSS == 10)
    {
      $SS=$SS+1;
      $MSS=0;
    }

if($SS == 60)
    {
      $MM=$MM+1;
      $SS=0;
    }

if($MM == 60)
    {
      $HH=$HH+1;
      $MM=0;
    }



print "$HH : $MM : $SS : $MSS";
print"\n";
print"            =============================\n";
$MSS=$MSS+1;
print "\n";
sleep 0.1;
}
