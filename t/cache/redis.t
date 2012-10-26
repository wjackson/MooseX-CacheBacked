use strict;
use warnings;
use v5.10;
use Test::More;
use Test::RedisServer;
use Redis;
use MooseX::CacheBacked::Cache::Redis;

{
    package C;

    use MooseX::CacheBacked;

    has color => ( is => 'rw', isa => 'Str' );
    has count => ( is => 'rw', isa => 'Int', incr => 1 );
}

my $redis_server = Test::RedisServer->new;
my $redis_client = Redis->new($redis_server->connect_info);
my $cache = MooseX::CacheBacked::Cache::Redis->new( redis => $redis_client );

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

$redis_client->incr('7:count');

is $c1->count, 6, 'attr reflects change in cache';

is $c1->incr_count, 7, 'incr method';
is $c1->count,      7, 'incr method';

is $c1->decr_count, 6, 'incr method';
is $c1->count,      6, 'incr method';

done_testing();
