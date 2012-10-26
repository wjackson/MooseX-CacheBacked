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
    return $self->store->{ $self->_key($id, $attr) };
}

sub set {
    my ($self, $id, $attr, $value) = @_;
    $self->store->{ $self->_key($id, $attr) } = $value;
    return;
}

sub incr {
    my ($self, $id, $attr) = @_;
    my $new_val = $self->get($id, $attr) + 1;
    $self->set($id, $attr, $new_val);
    return $new_val;
}

sub decr {
    my ($self, $id, $attr) = @_;
    my $new_val = $self->get($id, $attr) - 1;
    $self->set($id, $attr, $new_val);
    return $new_val;
}

1;
