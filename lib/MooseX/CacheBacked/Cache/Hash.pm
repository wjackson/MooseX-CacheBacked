package MooseX::CacheBacked::Cache::Hash;

use Moose;

with 'MooseX::CacheBacked::Cache';

has store => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
    lazy    => 1,
);

sub get {
    my ($self, $id, $attr) = @_;
    my $cache_key = $id . ':' . $attr;
    return $self->store->{$cache_key};
}

sub set {
    my ($self, $id, $attr, $value) = @_;
    my $cache_key = $id . ':' . $attr;
    $self->store->{$cache_key} = $value;
    return;
}

1;
