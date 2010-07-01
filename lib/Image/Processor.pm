package Image::Processor;

use strict;
use warnings;

require File::Path;
require File::Spec;
require File::Basename;

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

sub load { Image::Processor::Image->new(backend => shift->{backend})->load(@_) }

package Image::Processor::Image;

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

    return unless $self->{backend}->load($file);

    return $self;
}

sub process {
    my $self   = shift;
    my $params = shift;

    $params ||= {};

    $params->{bgcolor} ||= '#ffffff';

    if ($params->{size}) {
        my $w = $self->{backend}->width;
        my $h = $self->{backend}->height;

        my $tf = Image::Processor::Util->calculate(
            $w . 'x' . $h => $params->{size},
            $params
        );

        $self->{backend}->crop(%{$tf->{crop}})   if $tf->{crop};
        $self->{backend}->scale(%{$tf->{scale}}) if $tf->{scale};
        $self->{backend}->paste(color => $params->{bgcolor}, %{$tf->{paste}})
          if $tf->{paste};
    }

    return $self;
}

sub save {
    my $self = shift;
    my $file = shift;

    my $dir = File::Basename::dirname($file);

    File::Path::mkpath($dir) or die qq/Can't make directory "$dir": $!/;

    return unless $self->{backend}->save($file);

    return $self;
}

1;
