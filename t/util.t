#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 21;

use_ok('Image::Processor::Util');

my $r = 'Image::Processor::Util';

is_deeply($r->calculate('50x50' => '50x50'), {});
is_deeply(
    $r->calculate('100x100' => '50x50'),
    {scale => {width => 50, height => 50}}
);
is_deeply(
    $r->calculate('100x50' => '50x50'),
    {crop => {left => 25, width => 50}}
);
is_deeply(
    $r->calculate('100x50' => '50x50', {crop => 0}),
    {   paste => {width => 50, height => 50, left => 0, top => 25 / 2},
        scale => {width => 50, height => 25}
    }
);
is_deeply(
    $r->calculate('50x100' => '50x50'),
    {crop => {top => 25, height => 50}}
);
is_deeply(
    $r->calculate('150x100' => '50x50'),
    {crop => {left => 25, width => 100}, scale => {width => 50, height => 50}}
);
is_deeply(
    $r->calculate('150x100' => '50x50', {crop => 0}),
    {   paste =>
          {width => 50, height => 50, top => (50 - 100 / 3.0) / 2.0, left => 0},
        scale => {width => 50, height => 100 / 3}
    }
);


is_deeply($r->calculate('25x50' => '25x50'), {});
is_deeply(
    $r->calculate('100x100' => '25x50'),
    {crop => {left => 25, width => 50}, scale => {width => 25, height => 50}}
);
is_deeply(
    $r->calculate('100x50' => '25x50'),
    {crop => {left => 75/2, width => 25}}
);
is_deeply(
    $r->calculate('50x100' => '25x50'),
    {scale => {width => 25, height => 50}}
);
is_deeply(
    $r->calculate('150x100' => '25x50'),
    {crop => {left => 50, width => 50}, scale => {width => 25, height => 50}}
);


is_deeply($r->calculate('50x25' => '50x25'), {});
is_deeply(
    $r->calculate('100x100' => '50x25'),
    {crop => {top => 25, height => 50}, scale => {width => 50, height => 25}}
);
is_deeply(
    $r->calculate('100x50' => '50x25'),
    {scale => {width => 50, height => 25}}
);
is_deeply(
    $r->calculate('50x100' => '50x25'),
    {crop => {top => 75/2, height => 25}}
);
is_deeply(
    $r->calculate('150x100' => '50x25'),
    {crop => {top => 25/2, height => 75}, scale => {width => 50, height => 25}}
);


is_deeply($r->calculate('50x25' => '50x'), {});
is_deeply(
    $r->calculate('100x100' => '50x'),
    {scale => {width => 50, height => 50}}
);
is_deeply(
    $r->calculate('100x50' => '50x'),
    {scale => {width => 50, height => 25}}
);
is_deeply( $r->calculate('50x100' => '50x'), {});
is_deeply(
    $r->calculate('150x100' => '50x'),
    {scale => {width => 50, height => 100/3}}
);

is_deeply($r->calculate('50x50' => '100x100'),
    {paste => {width => 100, height => 100, top => 25, left => 25}});
