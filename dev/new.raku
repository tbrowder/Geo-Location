#!/usr/bin/env raku

my @s =
    #     GEOLOCATION="lat(42.4),lon(13.6),name('Baz Beach')";
    "lat(42.4),lon(13.6),name('Baz Beach')",

    #     GEOLOCATION='lat(42.4),lon(13.6),name("Baz Beach")';
    'lat(42.4),lon(13.6),name("Baz Beach")',

    #     GEOLOCATION='lat(42.4),lon(13.6),name(BazBeach)';
    'lat(42.4),lon(13.6),name(BazBeach)',

;

for @s -> $s {
    say "========================";
    say "incoming env var: |$s|";
    say "------------------------";
    my @w = split ',', $s;
    #say @w.raku;
    for @w -> $w {
        say "  attr(val): |$w|"; 
        my ($attr, $val);;
        if $w ~~ /(\w+) '(' 
                    [\'|\"]? 
                  (<-[\(\)\'\"]>+) 
                    [\'|\"]? 
                 ')' $/ {
            $attr = ~$0;
            $val  = ~$1;
        }
        else {
            die "FATAL: Unable to parse |$w|";
        }
        say "    parsed: {$attr}({$val})"; 
    }
}


=finish

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


