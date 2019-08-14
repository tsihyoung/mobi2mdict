#!/usr/bin/perl
open(FILE,$ARGV[0]);
my $prev = "";
while (my $line = <FILE>) {
  $prev =~ s/\n//;
  if ($line =~ /<idx:iform name="" value="(.*?)"\/>/) {
    my @matches = $line =~ /<idx:iform name="" value="(.*?)"\/>/g;
    foreach (@matches) {
      if (substr($_, 0, 1) =~ /[^\-(]/) {
        print "$_\n<div>la flexion de <b><a href=\"entry\:\/\/$prev\">$prev<\/b><\/div>\n<\/>\n";
      }
    }
  }
  $prev = $line;
}
