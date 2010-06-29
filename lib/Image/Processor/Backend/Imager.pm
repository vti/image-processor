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

    return $self->image->read(file => $path);
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
    );
    return unless $image;

    $self->image($image);
    return 1;
}

sub save {
    my $self = shift;
    my ($path) = @_;

    return $self->image->write(file => $path);
}

1;
