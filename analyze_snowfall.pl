#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# CST,Max TemperatureF,Mean TemperatureF,Min TemperatureF,Max Dew PointF,MeanDew PointF,Min DewpointF,Max Humidity, Mean Humidity, Min Humidity, Max Sea Level PressureIn, Mean Sea Level PressureIn, Min Sea Level PressureIn, Max VisibilityMiles, Mean VisibilityMiles, Min VisibilityMiles, Max Wind SpeedMPH, Mean Wind SpeedMPH, Max Gust SpeedMPH,PrecipitationIn, CloudCover, Events, WindDirDegrees

# Wind Chill = 35.74 + 0.6215T – 35.75(V^0.16) + 0.4275T(V^0.16)

my $header = <>;
my $i = 0;
my %header = map {$_ => $i++} split(/\s*,\s*/, $header);
my %data;
while(my $row = <>) {
    my $j = 0;
    my @row = split(/\s*,\s*/, $row);
    my %row = map {$_ => $row[$header{$_}]} keys %header;
    my $date = $row{'CST'};
    my $i = $row{'PrecipitationIn'};
    next unless length($i);
    next if $i eq 'T';
    $i *= 20; # http://help.wunderground.com/knowledgebase/articles/129077-where-can-i-find-historical-snowfall-data
    next unless $row{'Events'} =~ m/Snow/;
    next unless $i > 10;
    print "$date $i\n";
    my ($y, $m, $d) = split(/-/, $date);
    $data{$y}++;
}

foreach my $key (sort keys %data) {
    print "$key $data{$key}\n";
}
