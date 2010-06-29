package Image::Processor;

use strict;
use warnings;

require File::Path;
require File::Spec;

use Image::Processor::Util;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{backends} ||= [qw/Imager/];

    my $backend;
    foreach my $name (@{$self->{backends}}) {
        my $class = 'Image::Processor::Backend::' . $name;
        local $@;
        eval "require $class;";
        $backend = $class->new unless $@;
    }

    die 'No backend found' unless $backend;

    $self->{backend} = $backend;

    return $self;
}

sub load { Image::Processor::Worker->new(backend => shift->{backend})->load(@_) }

package Image::Processor::Worker;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub load {
    my $self = shift;
    my $file = shift;

    $self->{backend}->load($file);

    return $self;
}

sub resize {
    my $self = shift;
    my $size = shift;
    my $params = shift;

    $params = {};

    my $w = $self->{backend}->width;
    my $h = $self->{backend}->height;

    my $tf = Image::Processor::Util->calculate($w . 'x' . $h => $size, $params);

    $self->{backend}->crop(%{$tf->{crop}})   if $tf->{crop};
    $self->{backend}->scale(%{$tf->{scale}}) if $tf->{scale};

    return $self;
}

sub save {
    my $self = shift;
    my $file = shift;

    $self->{backend}->save($file);
}

1;
