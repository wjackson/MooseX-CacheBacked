use strict;
use warnings;
use Test::More;

{
    package Class;

    use Moose;
    use MooseX::CacheBacked;

    has id    => ( is => 'ro', isa => 'Str' );
    has color => ( is => 'rw', isa => 'Str' );
    has size  => ( is => 'rw', isa => 'Int' );
}

my $c = Class->new(id => '1234', color => 'red');

isa_ok $c, 'Class';
is $c->id,    '1234', 'set id by init_args';
is $c->color, 'red', 'set by init_args';
is $c->size,  undef, 'unset by init_args';

$c->color('blue');
$c->size(10);

is $c->color, 'blue', 'set by writer';
is $c->size,  '10',   'set by writer';

## look directly at the backend
is_deeply
    $c,
    {
        cache => {
            store => {
                color => 'blue',
                size  => 10,
                id => 1234,
            },
        },
    },
    'backend';

## modify the backend value
$c->{cache}->{store}->{size}++;
is $c->size, '11', 'set through backend';

done_testing;
