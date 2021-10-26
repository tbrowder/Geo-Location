use Test;

use Geo::Location;

plan 40;

# test defaults
my $loc = Geo::Location.new;

is $loc.lat,  30.35616;
is $loc.lon, -87.17095;
is $loc.city, "Gulf Breeze";
is $loc.state, "FL";
is $loc.country, "US";
is $loc.county, "Santa Rosa";
is $loc.id, 0;
is $loc.name, "Gulf Breeze, FL, USA";
is $loc.timezone, 'CST';

# now a bogus location
$loc = Geo::Location.new: :id(9999), :lat(10), :lon(20);
is $loc.lat, 10;
is $loc.lon, 20;
is $loc.id, 9999;

# from JSON
my $json = q:to/HERE/;
{
  "name" : "Foo Town",
  "lat"  : 34.42,
  "lon"  : -42.3
}
HERE

$loc = Geo::Location.new: :$json;
is $loc.lat, 34.42;
is $loc.lon, -42.3;
is $loc.name, "Foo Town";

# use coords of Okaloosa County EMS;
# from defaults of the obsolete DateTime::Location
my $lat =  30.485092;
my $lon = -86.4376157;
$loc = Geo::Location.new: :$lat, :$lon;
is $loc.lat, $lat;
is $loc.lon, $lon;
is $loc.lat-dms, "N30d29m6s";
is $loc.lon-dms, "W86d26m15s";
is $loc.lat-rst, "30N29";
is $loc.lon-rst, "86W26";
is $loc.riseset-format, "30N29 86W26";
is $loc.location, "lat: 30.485092, lon: -86.4376157";
is $loc.location(:format('dms')), "lat: N30d29m6s, lon: W86d26m15s";
is $loc.location(:format('DMS')), "lat: N30d29m6s, lon: W86d26m15s";
is $loc.location(:format('decimal')), "lat: 30.485092, lon: -86.4376157";
is $loc.location(:format('DECIMAL')), "lat: 30.485092, lon: -86.4376157";
is $loc.location(:format('dec')), "lat: 30.485092, lon: -86.4376157";
is $loc.location(:format('DEC')), "lat: 30.485092, lon: -86.4376157";
is $loc.location(:format('RST')), "lat: 30N29, lon: 86W26";
is $loc.location(:format('rst')), "lat: 30N29, lon: 86W26";

my @env-loc =
    #     GEOLOCATION="lat(42.4),lon(13.6),name('Baz Beach')";
    "lat(42.4),lon(13.6),name('Baz Beach')",

    #     GEOLOCATION='lat(42.4),lon(13.6),name("Baz Beach")';
    'lat(42.4),lon(13.6),name("Baz Beach")',

    #     GEOLOCATION='lat(42.4),lon(13.6),name(BazBeach)';
    'lat(42.4),lon(13.6),name(BazBeach)',
;

for @env-loc.kv -> $i, $env {
    # 8 tests per pass

    %*ENV<GEO_LOCATION> = $env;

    # testing default with the env var defined
    # 3 tests
    $loc = Geo::Location.new; 
    is $loc.lat, 42.4;
    is $loc.lon, 13.6;
    when $i < 2 {
        is $loc.name, "Baz Beach";
    }
    when $i == 2 {
        is $loc.name, "BazBeach";
    }

    # testing with the other methods which override the env var

    # lat/lon
    # 2 tests
    my $lat =  30.485092;
    my $lon = -86.4376157;
    $loc = Geo::Location.new: :$lat, :$lon;
    is $loc.lat, $lat;
    is $loc.lon, $lon;

    # json
    $loc = Geo::Location.new: :$json;
    # 3 tests
    is $loc.lat, 34.42;
    is $loc.lon, -42.3;
    is $loc.name, "Foo Town";
}

