#!/usr/bin/perl
use List::MoreUtils qw(uniq);

open(FILE,$ARGV[0]) or die "File failed to open: $!";
my @dict = <FILE>;
close FILE;

print "Preprocessing HTML format...\n";

foreach (@dict) {
    $_ =~ s/<idx:entry scriptable="yes">/\n<\/>\n/g;
    $_ =~ s/<\/idx:entry>//g;
    $_ =~ s/<idx:orth value="(.*?)">/\1\n/g;
    $_ =~ s/<\/idx:orth>//g;
    $_ =~ s/<hr\/>//g;
    $_ =~ s/<mbp:frameset>//g;
    $_ =~ s/<\/mbp:frameset>//g;
    $_ =~ s/<mbp:pagebreak\/>//g;
    $_ =~ s/<html>//g;
    $_ =~ s/<\/html>//g;
    $_ =~ s/<body>//g;
    $_ =~ s/<\/body>//g;
}
$dict[-1] .= "\n<\/>\n";

open(FILE,"+>",$ARGV[0]) or die "File failed to open: $!";
print FILE @dict;
close FILE;

open(FILE,$ARGV[0]) or die "File failed to open: $!";
my @dict = <FILE>;

my @copyright = splice(@dict,0,2);
open(COPYRIGHT,"+>","copyright.txt") or die "File failed to open: $!";
print COPYRIGHT $copyright[0];
close COPYRIGHT;

seek(FILE, 0, 0);
my $prev = "";
while (my $line = <FILE>) {
    $prev =~ s/\n//;
    if (my @ids = uniq($line =~ /a id="(.*?)"/g)) {
        for $id (@ids) {
            print "processing: $id\n";
            foreach (@dict) {
                $_ =~ s/<a  href="#$id" >/<a href="entry:\/\/$prev">/g;
                $_ =~ s/<a id="$id" \/>//g;
            }
        }
    }
    $prev = $line;
}

close FILE;

my @inflections = ();
$prev = "";
for $line (@dict) {
    if ($line =~ /<idx:iform name="" value="(.*?)"\/>/) {
        print "processing: $prev";
        $prev =~ s/\n//;
        foreach ($line =~ /<idx:iform name="" value="(.*?)"\/>/g) {
            if (substr($_, 0, 1) =~ /[^\-(]/ && $_ ne $prev) {
                push @inflections, "$_\n<div>la flexion de <b><a href=\"entry://$prev\">$prev</b></div>\n</>\n";
            }
        }
        $line =~ s/<idx:infl>(.*)<\/idx:infl>(.*?)<\/div>/\2<\/div><div>\1<\/div>/;
        $line =~ s/<idx:iform name="" value="(.*?)"\/>/\1 /g;
    }
    $prev = $line;
}

open(FILE,"+>",$ARGV[0]) or die "File failed to open: $!";
print FILE @dict, @inflections;
close FILE;

print "All done\n";
