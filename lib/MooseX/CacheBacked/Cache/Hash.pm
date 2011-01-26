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

sub _key {
    my ($self, $id, $attr) = @_;

    confess q{Argument 'id' isn't defined}   if !defined $id;
    confess q{Argument 'attr' isn't defined} if !defined $attr;

    return $id . ':' . $attr;
}

1;
