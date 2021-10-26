#!/usr/bin/env raku

use JSON::Fast;
use lib '../lib';
use Geo::Location;

my $jstr = q:to/HERE/;
{
  "name" : "Foo Town",
  "lon"  : 32.3,
  "lat"  : -24
}
HERE

my $jstr2 = q:to/HERE/;
{
  "id" : {
  "name" : "Foo Town",
  "lon"  : 32.3,
  "lat"  : -24
}
}
HERE

get-loc $jstr;

my %h2 = from-json $jstr2;
say %h2;

#sub get-loc($jstr --> Geo::Location) {
sub get-loc($jstr) {
    my %h = from-json $jstr;
    say %h.raku;
    my $loc = Geo::Location.new: :name(%h<name>), :lat(%h<lat>), :lon(%h<lon>);
    say $loc.raku;
}
