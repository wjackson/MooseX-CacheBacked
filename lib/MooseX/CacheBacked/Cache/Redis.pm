package MooseX::CacheBacked::Cache::Redis;

use Moose;

with 'MooseX::CacheBacked::Cache';

has redis => ( is => 'ro', isa => 'Redis', required => 1);

sub get {
    my ($self, $id, $attr) = @_;
    my $key = $self->_key($id, $attr);
    return $self->redis->get($key);
}

sub set {
    my ($self, $id, $attr, $value) = @_;
    my $key = $self->_key($id, $attr);
    $self->redis->set($key, $value);
    return;
}

sub incr {
    my ($self, $id, $attr) = @_;
    my $key = $self->_key($id, $attr);
    return $self->redis->incr($key);
}

sub decr {
    my ($self, $id, $attr) = @_;
    my $key = $self->_key($id, $attr);
    return $self->redis->decr($key);
}

1;
