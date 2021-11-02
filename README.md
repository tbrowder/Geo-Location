[![Actions Status](https://github.com/tbrowder/Geo-Location/workflows/test/badge.svg)](https://github.com/tbrowder/Geo-Location/actions)

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
30.485092
say $loc.lon;
-86.4376157
```

DESCRIPTION
===========

**Geo::Location** Allows the user to define a geographical location for easy use either by manual entry, from a JSON description, or an environment variable (`GEO_LOCATION`).

For now one must enter latitude and longitude using signed decimal numbers. One easy way to find those for a location is to use Google Maps (on a PC) and drop a location pin with its point at the place of interest. Then select the pin, right-click, and see the lat/lon on the first line of data. (I have had some success also with doing that on an iPad, but it's a bit trickier for my tastes, hence my use of a PC for real mapping uses.)

Note the object has only two required parameters ($lat, $lon), but there are nine other attributes available. See them listed below.

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

Define desired attributes just like a manual entry but without the colons. Use double quotes on the entire value and single quotes inside, or the reverse, as desired. Note also strings without spaces do not require quotes inside the parentheses. Note also this is only used when (1) no manual or json methods are used and (2) a valid `GEO_LOCATION` environment variable is defined in the using environment.

    $ export GEO_LOCATION="lat(42.4),lon(13.6),name('Baz Beach')";

### Class attributes

There are eleven total public attributes in the class.

  * city

  * country 

    typically a two-character ISO code

  * county

  * id 

    use as unique reference in a collection

  * lat

  * lon

  * name 

    a convenient display name

  * notes

  * region 

    **EU**, etc., multi-country area with DST rules

  * state 

    typically a two-letter ISO code, for example, a US state

  * timezone 

    use as a reference time zone abbreviation for use with module **DateTime::US**

### Class methods

In addition to the methods provided for the public attributes listed above, the following added methods provide some other ways of showing object data.

  * **lat-dms**(--> Str) {...}

    Returns the latitude in DMS format

  * **lon-dms**(--> Str) {...}

    Returns the longitude in DMS format

  * **riseset-format**(:bare --> Str) {...}

    Returns the format required by the Perl programs accompanying CPAN Perl module **Astro::Montenbruck** (in this module the format will also be referred to as '**RST**'):

        ./script/riseset.pl --place=30N29 86W26 --twilight=civil

    Note that Perl module's convention for the sign of East longitude is negative instead of positive for decimal entries, so it is important to use the provided RST format to avoid longitude errors.

  * **lat-rst**(--> Str) {...}

    Returns the latitude in RST format

  * **lon-rst**(--> Str) {...}

    Returns the longitude in RST format

  * **location**(:$format = 'decimal', :bare --> Str) {

    Returns the location in a single string in the specified format. For example:

    In default decimal:

        say $loc.location;
        lat: 30.485092, lon: -86.4376157
        say $loc.location(:bare);
        30.485092 -86.4376157

    Or in DMS:

        say $loc.location(:format('dms');
        lat: N30d29m6s, lon: W86d26m15s
        say $loc.location(:format('dms'), :bare);
        N30d29m6s W86d26m15s

    Or in RST:

        say $loc.location(:format('rst'), :plain);
        lat: 30N29, lon: 86W26
        say $loc.location(:format('rst', :plain);
        30N29 86W26

To Do
=====

  * Allow other forms of lat/lon entry besides decimal

  * Provide more methods for astronomical use

  * Prove enums for use with argument entry

AUTHOR
======

Tom Browder `tom.browder@cpan.org`

COPYRIGHT AND LICENSE
=====================

© 2020 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

