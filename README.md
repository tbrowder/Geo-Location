NAME
====

`Geo::Location` - Provides location data for astronomical and other programs

SYNOPSIS
========

Use the default location:

```raku
$ raku
> use Geo::Location;
> my $loc = Location.new; # note no arguments entered here
> say $loc.name;
Gulf Breeze, FL, USA
> say $loc.location;
lat: 30.485092, lon: -86.4376157
say $loc.lat;
say $loc.long;
```

DESCRIPTION
===========

**Geo::Location** Allows the user to define a geographical location for easy use either by manual entry, from a JSON description, or an environment variable (`GEO_LOCATION`).

For now one must enter latitude and longitude using signed decimal numbers. One easy way to find those for a location is to use Google Maps (on a PC) and drop a location pin with its point at the place of interest. Then select the pin, right-click and see the lat/lon on the first line of data. (I have had some success also with doing that on an iPad, but it's a bit trickier for my tastes, hence my use of the PC for real mapping uses.)

Note the object has only two required parameters ($lat, $lon), but there are nine other attribute available. See them listed below.

### Class construction

Use the manual entry:

    my $loc = Geo::Location.new: :lat(-36.23), :lon(+12);

Use a JSON description:

    my $json = q:to/HERE/;
    {
        "name" : "Foo Town",
        "lat"  : 35.267,
        "lon"  : -42.3
    }
    HERE
    my $loc = Geo::Location.new: :$json;

Use an environment variable:

Define desired attributes just like a manual entry but without the colons. Use double quotes on the entire value and single quotes inside, or the reverse, as desired. Note also strings without spaces do not require quotes inside the parentheses.

    $ export GEOLOCATION="lat(42.4),lon(13.6),name('Baz Beach')";

### Class attributes

  * city

  * country # two-char ISO code

  * county

  * id # a unique id in a collection

  * lat

  * lon

  * name # a convenient display name

  * notes

  * region # EU, etc., multi-country area with DST rules

  * state # two-letter ISO code

  * timezone # for use with module DateTime::US

To Do
=====

Allow other forms of lat/lon entry besides decimal.

AUTHOR
======

Tom Browder `tom.browder@cpan.org`

COPYRIGHT AND LICENSE
=====================

© 2020 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

