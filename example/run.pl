#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";

use Image::Processor;

my $p = Image::Processor->new;

my @params = (
    ['100x100'],
    ['100x100', crop => 0, bg => '#000000'],
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

    my $size = shift @$param;
    my %args = @$param;
    my $printable_params = $size;
    $printable_params
      .= ', ' . join ', ' => map { $_ . '=>' . $args{$_} } keys %args
      if %args;

    print <<EOF;
<img src="data/linux-$suffix.png" border="1" /><br />
$printable_params<br /><br />
EOF
}

print <<EOF;
</body>
</html>
EOF
