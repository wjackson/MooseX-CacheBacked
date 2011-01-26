use strict;
use warnings;
use Test::More;
use MooseX::CacheBacked::Cache::Hash;

{
    package C;

    use MooseX::CacheBacked;

    has color => ( is => 'rw', isa => 'Str' );
    has size  => ( is => 'rw', isa => 'Int' );
}

my $cache = MooseX::CacheBacked::Cache::Hash->new;

my $c = C->new(
    cache => $cache,
    id    => '1234',
    color => 'red',
);

isa_ok $c, 'C';
is $c->id,    '1234', 'set id by init_args';
is $c->color, 'red',  'set by init_args';
is $c->size,  undef,  'unset by init_args';

$c->color('blue');
$c->size(10);

is $c->color, 'blue', 'set by writer';
is $c->size,  '10',   'set by writer';

is $c->cache->get('1234', 'id'),    '1234', 'backend id';
is $c->cache->get('1234', 'color'), 'blue', 'backend color';
is $c->cache->get('1234', 'size'),  '10',   'backend size';

# modify the backend value
$c->cache->set( '1234', 'size', $c->cache->get('1234', 'size')+1 );
is $c->size, '11', 'set through backend';

done_testing;
