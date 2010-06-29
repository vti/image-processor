package Image::Processor::Util;

use strict;
use warnings;

sub calculate {
    my ($class, $from, $to, $params) = @_;

    my ($w,  $h)  = split 'x' => $from;
    my ($w_, $h_) = split 'x' => $to;

    $params ||= {};

    my $method = $params->{method};
    my $strict = $params->{strict};

    my $align = $params->{align};
    $align = $align && $align > 0 && $align < 1 ? $align : 0.5;

    my $bgcolor = $params->{bgcolor};

    my $enlarge = $params->{enlarge};
    $enlarge = 1 unless defined $enlarge;

    my $tf = {};

    if ($w_ && $h_) {
        my ($w_k, $h_k);
        my $r  = $w / $h;
        my $r_ = $w_ / $h_;
        if ($r != $r_) {
            if ($r < $r_) {
                $h_k = ($w * $h_) / ($w_ * $h);
            }
            else {
                $w_k = ($w_ * $h) / ($w * $h_);
            }
        }

        if ($w_k) {
            if (my $d = ($w - $w * $w_k) * $align) {
                $tf->{crop}->{left}  = $d;
                $w                   = $w - $d * 2;
                $tf->{crop}->{width} = $w;
            }
        }
        elsif ($h_k) {
            if (my $d = ($h - $h * $h_k) * $align) {
                $tf->{crop}->{top}    = $d;
                $h                    = $h - $d * 2;
                $tf->{crop}->{height} = $h;
            }
        }
    }
    elsif ($w_) {
        $h_ = $w_ / $w * $h;
    }
    elsif ($h_) {
        $w_ = $h_ / $h * $w;
    }

    unless ($w == $w_ && $h == $h_) {
        $tf->{scale} = {width => $w_, height => $h_};
    }

    return $tf;
}

1;