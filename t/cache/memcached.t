use strict;
use warnings;
use Test::More;
use Test::Memcached;
use Cache::Memcached;
use Moose;
use MooseX::CacheBacked::Cache::Memcached;

{
    package C;

    use MooseX::CacheBacked;

    has color => ( is => 'rw', isa => 'Str' );
    has count => ( is => 'rw', isa => 'Int' );
}

my $memd_server = Test::Memcached->new();
$memd_server->start;
my $port = $memd_server->option('tcp_port');

# memcached client
my $memd = Cache::Memcached->new({
    servers => [ "127.0.0.1:$port" ]
});

# cache for backing objects
my $cache = MooseX::CacheBacked::Cache::Memcached->new( memd => $memd );

my $c1 = C->new(
    cache => $cache,
    id    => 7,
    color => 'blue',
    count => 5,
);

my $c2 = C->new(
    cache => $cache,
    id    => 7,
);

is $c1->color, 'blue', 'read color from 1st object';
is $c1->count, 5,      'read count from 1st object';
is $c2->color, 'blue', 'read color from 2nd object';
is $c2->count, 5,      'read count from 2nd object';

$c2->color('red');

is $c1->color, 'red', 'write attr from 2nd object';

$memd->incr('7:count');

is $c1->count, 6, 'attr reflects change in cache';

$memd_server->stop;

done_testing();
