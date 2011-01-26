package MooseX::CacheBacked::Cache::Memcached;

use Moose;

with 'MooseX::CacheBacked::Cache';

has memd => ( is => 'ro', isa => 'Cache::Memcached', required => 1);

sub get {
    my ($self, $id, $attr) = @_;
    my $key = $self->_key($id, $attr);
    return $self->memd->get($key);
}

sub set {
    my ($self, $id, $attr, $value) = @_;
    my $key = $self->_key($id, $attr);
    $self->memd->set($key, $value);
    return;
}

1;
