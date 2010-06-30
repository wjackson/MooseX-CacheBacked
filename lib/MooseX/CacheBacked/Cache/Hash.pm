package MooseX::CacheBacked::Cache::Hash;

use Moose::Role;

has store => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
    lazy    => 1,
);

sub get_attr {
    my ($self, $k) = @_;
    return $self->store->{$self->id}->{$k};
}

sub set_attr {
    my ($self, $k, $v) = @_;
    my $id = $self->id;

    confess 'No value for attribute id'
        if !defined $id;

    $self->store->{$self->id}->{$k} = $v;
    return;
}

1;
