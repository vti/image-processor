package Image::Processor::Backend::Imager;

use strict;
use warnings;

use base 'Image::Processor::Backend';

use Imager;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{image} = Imager->new;

    return $self;
}

sub image { @_ > 1 ? $_[0]->{image} = $_[1] : $_[0]->{image} }

sub load {
    my $self = shift;
    my ($path) = @_;

    return $self->image->read(file => $path) or die Imager->errstr;
}

sub width  { shift->image->getwidth }
sub height { shift->image->getheight }

sub scale {
    my $self = shift;
    my %params = @_;

    my $image = $self->image->scale(
        xpixels => $params{width},
        ypixels => $params{height}
    );
    return unless $image;

    $self->image($image);
    return 1;
}

sub crop {
    my $self = shift;
    my %params = @_;

    my $image = $self->image->crop(
        left   => $params{left},
        width  => $params{width},
        top    => $params{top},
        height => $params{height}
    ) or die Imager->errstr;

    $self->image($image);
    return 1;
}

sub paste {
    my $self   = shift;
    my %params = @_;

    my $out = Imager->new(
        xsize => $params{width},
        ysize => $params{height}
    );
    $out->box(filled => 1, color => $params{color});
    $out->paste(
        left => $params{left},
        top  => $params{top},
        img  => $self->image
    );

    $self->image($out);

    return 1;
}

sub save {
    my $self = shift;
    my ($path) = @_;

    return $self->image->write(file => $path) or die Imager->errstr;
}

1;
