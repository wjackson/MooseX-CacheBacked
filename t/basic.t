use strict;
use warnings;
use Test::More;

{ # simple hash based cache implemntation for testing
    package TestCache;
    use Moose::Role;
    with 'MooseX::CacheBacked::CacheRole';

    has store => (
        is      => 'ro',
        isa     => 'HashRef',
        default => sub { {} },
        lazy    => 1,
    );

    sub id { 'abcd' };

    sub get_attr {
        my ($self, $k) = @_;
        return $self->store->{$k};
    }

    sub set_attr {
        my ($self, $k, $v) = @_;
        $self->store->{$k} = $v;
        return;
    }
}

{
    package Class;
    use Moose;
    use MooseX::CacheBacked;

    with qw(TestCache MooseX::CacheBacked::CacheRole);

    has color => ( is => 'rw', isa => 'Str' );
    has size  => ( is => 'rw', isa => 'Int' );
}

my $c = Class->new(color => 'red');

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
        color => 'blue',
        size  => 10,
    },
    'backend';

# modify the backend value
$c->store->{size}++;
is $c->size, '11', 'set through backend';

done_testing;
