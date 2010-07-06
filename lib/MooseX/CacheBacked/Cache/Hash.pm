package MooseX::CacheBacked::Cache::Hash;

use Moose;

with 'MooseX::CacheBacked::Cache';

has store => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
    lazy    => 1,
);

sub get_attr {
    my ($self, $k) = @_;
    return $self->store->{$k};
}

sub set_attr {
    my ($self, $k, $v) = @_;
    $self->store->{$k} = $v;
    return;
}

1;
