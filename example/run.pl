#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";

use Data::Dumper;
use Image::Processor;

my $p = Image::Processor->new;

my @params = (
    [{size => '100x100'}],
    [{size => '100x100', crop => 0, bgcolor => '#000000'}],
    [{size => '500x600', crop => 0, bgcolor => '#000000'}],
    [{size => '100x'}],
    [{size => 'x100'}]
);

print <<EOF;
<html>
<body>
<img src="linux.png" border="1" /><br />
Original<br />
<br />
EOF

my $i = 0;
foreach my $param (@params) {
    my $suffix = $i++;

    $p->load("$FindBin::Bin/linux.png")->process(@$param)
      ->save("$FindBin::Bin/data/linux-$suffix.png");

    my $printable_params = Dumper($param);

    print <<EOF;
<img src="data/linux-$suffix.png" border="1" /><br />
$printable_params<br /><br />
EOF
}

print <<EOF;
</body>
</html>
EOF
