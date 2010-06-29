#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";

use Data::Dumper;
use Image::Processor;

my $p = Image::Processor->new;

my @params = (
    ['100x100'],
    ['100x100', {crop => 0, bgcolor => '#000000'}],
    ['100x'],
    ['x100']
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

    $p->load("$FindBin::Bin/linux.png")->resize(@$param)
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
