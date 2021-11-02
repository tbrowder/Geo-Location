unit class Geo::Location:ver<0.0.2>:auth<cpan:TBROWDER>;

my %attrs; # defined in BEGIN block just prior to EOF

# mandatory attributes
# (note use a PC, place an info pin with point at the desired place,
#  select the pin, and right-click on it to display lat/long at the top)
has $.lat;  # decimal degrees: +north, -south
has $.lon;  # decimal degrees: +east, -west

# if lat/lon are not entered, then check these
# for instantiation:
has Str $.json;

# other known attributes
has $.name; # a convenient display name
has $.id;                # a unique id in a collection
has $.timezone;          # for use with module DateTime::US
has $.city;
has $.state;     # two-letter ISO code
has $.county;
has $.country;   # two-char ISO code
has $.region;    # EU, etc., multi-country area with DST rules
has $.notes;

submethod TWEAK {
    # first assume correct entries, in order

    # if lat and lon are defined, we're done
    if $!lat.defined and $!lon.defined {
        ; # ok
    }
    elsif $!json.defined {
        self!new-from-json
    }
    elsif %*ENV<GEO_LOCATION>:exists
        and %*ENV<GEO_LOCATION> ~~ /'lat('/
        and %*ENV<GEO_LOCATION> ~~ /'lon('/
        and %*ENV<GEO_LOCATION>.chars > 12 {
        # absolute minimum value: lat(0),lon(0)
        self!new-from-env
    }
    else {
        self!new-from-defaults
    }

    return;

    # handle and validate the lat/lon entries
    self!check-lat-lon($!lat, $!lon);
}

method !check-lat-lon($lat is copy, $lon is copy) {
    my $ret-val = 0;
    my $err     = 0;

    # try all combos
}

method lat-dms(:$debug --> Str) {
    # Returns the latitude in DMS format
    my $lat-sym = $.lat >= 0 ?? 'N' !! 'S';
    my $lat-deg = $.lat.truncate.abs;
    my $lat-deg-frac = $.lat.abs - $lat-deg;

    my $lat-min = ($lat-deg-frac * 60.0).round;
    my $lat-min-frac = $lat-deg-frac * 60 - $lat-min;

    my $lat-sec = ($lat-min-frac * 60.0).round;
    return "{$lat-sym}{$lat-deg}d{$lat-min}m{$lat-sec}s";
}

method lon-dms(:$debug --> Str) {
    # Returns the longitude in DMS format
    my $lon-sym = $.lon >= 0 ?? 'E' !! 'W';
    my $lon-deg = $.lon.truncate.abs;
    my $lon-deg-frac = $.lon.abs - $lon-deg;

    my $lon-min = ($lon-deg-frac * 60.0).round;
    my $lon-min-frac = $lon-deg-frac * 60 - $lon-min;

    my $lon-sec = ($lon-min-frac * 60.0).round;
    return "{$lon-sym}{$lon-deg}d{$lon-min}m{$lon-sec}s";
}

method lat-rst(:$debug --> Str) {
    self.riseset-format: :lat
}

method lon-rst(:$debug --> Str) {
    self.riseset-format: :lon
}

method riseset-format(:$location,
                      :$lat,
                      :$lon,
                      :$bare,
                      :$debug --> Str) {
    # Returns the format required by the Perl program 'riseset.pl' in
    # CPAN Perl module 'Astro::Montenbruck::RiseSet::RST':
    #
    #   ./script/riseset.pl --place=56N26 37E09 --twilight=civil

    my $lat-sym = $.lat >= 0 ?? 'N' !! 'S';
    my $lon-sym = $.lon >= 0 ?? 'E' !! 'W';

    my $lat-deg = $.lat.truncate.abs;
    my $lon-deg = $.lon.truncate.abs;

    my $lat-min = (($.lat.abs - $lat-deg).abs * 60.0).round;
    my $lon-min = (($.lon.abs - $lon-deg).abs * 60.0).round;

    if $lat {
        return "{$lat-deg}{$lat-sym}{$lat-min}";
    }
    elsif $lon {
        return "{$lon-deg}{$lon-sym}{$lon-min}";
    }
    elsif $location {
        return "{$lat-deg}{$lat-sym}{$lat-min} {$lon-deg}{$lon-sym}{$lon-min}" if $bare;
        return "lat: {$lat-deg}{$lat-sym}{$lat-min}, lon: {$lon-deg}{$lon-sym}{$lon-min}";
    }

    my $place = "{$lat-deg}{$lat-sym}{$lat-min} {$lon-deg}{$lon-sym}{$lon-min}";
    if 0 or $debug {
        note qq:to/HERE/;
        DEBUG:
        lat = {$.lat}
          lat-deg = {$lat-deg}
          lat-min = {$lat-min}

        lon = {$.lon}
          lon-deg = {$lon-deg}
          lon-min = {$lon-min}

        place: '{$place}'
        HERE
    }
    return $place;
}

sub convert-lat($lat) is export(:convert-lat) {
}

sub convert-lon($lon) is export(:convert-lon) {

}

method location(:$format = 'decimal', :$bare) {
    if $format ~~ /:i ^ dms/ {
        return "{self.lat-dms} {self.lon-dms}" if $bare;
        return "lat: {self.lat-dms}, lon: {self.lon-dms}";
    }
    elsif $format ~~ /:i ^ dec/ {
        return "{self.lat} {self.lon}" if $bare;
        return "lat: {self.lat}, lon: {self.lon}";
    }
    elsif $format ~~ /:i ^ rst/ {
        return self.riseset-format(:location, :bare) if $bare;
        return self.riseset-format(:location);
    }
    else {
        return "{self.lat} {self.lon}" if $bare;
        return "lat: {self.lat}, lon: {self.lon}";
        #say "TODO: lat/lon in deg/min/sec";
    }
}

method !new-from-json {
    use JSON::Fast;
    my %h = from-json $!json;
    # 11 recognized attributes
    for %h.keys -> $attr {
        die "FATAL: Unknown attribute '$attr'" unless %attrs{$attr}:exists;
        when $attr eq 'city'     { $!city     = %h{$attr} }
        when $attr eq 'country'  { $!country  = %h{$attr} }
        when $attr eq 'county'   { $!county   = %h{$attr} }
        when $attr eq 'id'       { $!id       = %h{$attr} }
        when $attr eq 'lat'      { $!lat      = %h{$attr} }
        when $attr eq 'lon'      { $!lon      = %h{$attr} }
        when $attr eq 'name'     { $!name     = %h{$attr} }
        when $attr eq 'notes'    { $!notes    = %h{$attr} }
        when $attr eq 'region'   { $!region   = %h{$attr} }
        when $attr eq 'state'    { $!state    = %h{$attr} }
        when $attr eq 'timezone' { $!timezone = %h{$attr} }
    }
}

method !new-from-env(:$debug) {
    # 11 recognized attributes
    # some test cases:
    #     GEOLOCATION="lat(42.4),lon(13.6),name('Baz Beach')";
    #     GEOLOCATION='lat(42.4),lon(13.6),name("Baz Beach")';
    #     GEOLOCATION='lat(42.4),lon(13.6),name(BazBeach)';
    my $s = %*ENV<GEO_LOCATION> // '';
    die "FATAL: Empty or undefined env var GEO_LOCATION" if not $s;
    my @w = split ',', $s;
    for @w -> $w {
        note "  attr(val): |$w|" if $debug;
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
        note "    parsed: {$attr}({$val})" if $debug;

        # use same scheme as new-from-json
        # 11 recognized attributes
        die "FATAL: Unknown attribute '$attr'" unless %attrs{$attr}:exists;

        when $attr eq 'city'     { $!city     = $val }
        when $attr eq 'country'  { $!country  = $val }
        when $attr eq 'county'   { $!county   = $val }
        when $attr eq 'id'       { $!id       = $val }
        when $attr eq 'lat'      { $!lat      = $val }
        when $attr eq 'lon'      { $!lon      = $val }
        when $attr eq 'name'     { $!name     = $val }
        when $attr eq 'notes'    { $!notes    = $val }
        when $attr eq 'region'   { $!region   = $val }
        when $attr eq 'state'    { $!state    = $val }
        when $attr eq 'timezone' { $!timezone = $val }
    }
}

method !new-from-defaults {
    $!name     = "Gulf Breeze, FL, USA";  # a convenient display name
    $!id       = 0;                       # a unique id in a collection
    # two more mandatory attributes (center of City Hall,from Google Maps):
    # (note use a PC, place an info pin with point at the desired place,
    #  select the pin, and right-click on it to display lat/long at the top)
    $!lat      =  30.35616;            # decimal degrees: +north, -south
    $!lon      = -87.17095;            # decimal degrees: +east, -west

    # other
    $!timezone = 'CST'; # CST          # for use with module DateTime::US

    # optional attributes:
    $!city    = "Gulf Breeze";
    $!state   = "FL";     # two-letter ISO code
    $!county  = "Santa Rosa";
    $!country = "US";   # two-char ISO code
    $!region  = '';    # EU, etc., multi-country area with DST rules
    $!notes   = "Coords are the center of Gulf Breeze City Hall as reported by Google Maps on 2021-10-24";
}

BEGIN {
    # the 11 recognized attributes
    # in alphabetical order
    %attrs = set [
        'city',
        'country',  # two-char ISO code
        'county',
        'id',       # a unique id in a collection
        'lat',
        'lon',
        'name',     # a convenient display name
        'notes',
        'region',   # EU, etc., multi-country area with DST rules
        'state',    # two-letter ISO code
        'timezone', # for use with module DateTime::US
    ];
}
