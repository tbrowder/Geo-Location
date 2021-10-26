unit class Foo;

use JSON::Fast;

has $.a;
has $.b;

sub new-from-json(Str $jstr) {
    my %h = from-json $jstr;
    Foo.new(|%h);
}

