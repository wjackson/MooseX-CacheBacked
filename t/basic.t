use strict;
use warnings;
use Test::More;

#{ # simple hash based cache implemntation for testing
#    package TestCache;
#    use Moose::Role;
#    with 'MooseX::CacheBacked::Cache';
#
#    has store => (
#        is      => 'ro',
#        isa     => 'HashRef',
#        default => sub { {} },
#        lazy    => 1,
#    );
#
#    sub id { 'abcd' };
#
#    sub get_attr {
#        my ($self, $k) = @_;
#        return $self->store->{$self->id}->{$k};
#    }
#
#    sub set_attr {
#        my ($self, $k, $v) = @_;
#        $self->store->{$self->id}->{$k} = $v;
#        return;
#    }
#}

{
    package Class;
    use Moose;
    use MooseX::CacheBacked;

    with qw(
        MooseX::CacheBacked::Cache
        MooseX::CacheBacked::Cache::Hash
    );

    has id    => ( is => 'ro', isa => 'Str' );
    has color => ( is => 'rw', isa => 'Str' );
    has size  => ( is => 'rw', isa => 'Int' );
}

my $c = Class->new(id => '1234', color => 'red');

isa_ok $c, 'Class';
is $c->color, 'red', 'set by init_args';
is $c->size,  undef, 'unset by init_args';


$c->color('blue');
$c->size(10);

is $c->color, 'blue', 'set by writer';
is $c->size,  '10',   'set by writer';

# look directly at the backend
is_deeply
    $c->store,
    {
        1234 => {
            color => 'blue',
            size  => 10,
        }
    },
    'backend';

# modify the backend value
$c->store->{1234}->{size}++;
is $c->size, '11', 'set through backend';

done_testing;
