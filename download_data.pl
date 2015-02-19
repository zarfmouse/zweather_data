#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;

my $station = "KMDW";
my $bdate = "1976-12-04";
my $edate = "2015-2-18";

my $header;
my @data;
do {
    warn "Fetching from $bdate. Have ".scalar(@data)." rows.\n";
    my ($by, $bm, $bd) = split(/-/, $bdate);
    my ($ey, $em, $ed) = split(/-/, $edate);    
    my $url = "http://www.wunderground.com/history/airport/KMDW/$by/$bm/$bd/CustomHistory.html?dayend=$ed&monthend=$em&yearend=$ey&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=&format=1";
    my $csv = get($url);
    my @csv = grep {length($_) > 0} map {s/\<br \/\>//; $_;} split(/\n/, $csv);
    $header = shift @csv;
    warn "HEADER: $header\n";
    my $last_line = pop @csv;
    my @last_line = split(',', $last_line);
    $bdate = $last_line[0];
    @data = (@data, @csv);
} until($bdate ge $edate);

print "$header\n".join("\n", @data)."\n";



