#!/usr/bin/env raku

use JSON::Fast;

use lib '.';
use Foo;

my $jstr = q:to/HERE/;
{
  "a" : "Foo Town",
  "b" : 32.3
}
HERE

my $f = from-json($jstr);
say $f.raku;

=finish

my %h = new-from-json $jstr;
say %h.raku;


