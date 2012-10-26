use strict;
use warnings;
use Test::More;
use MooseX::CacheBacked::Cache::Hash;

my $cache = MooseX::CacheBacked::Cache::Hash->new();

$cache->set(123, 'foo', 'bar');
is $cache->get(123, 'foo'), 'bar', 'get/set cache value';

$cache->set(123, 'i', 3);
$cache->incr(123, 'i');
is $cache->get(123, 'i'), 4, 'incr worked';

$cache->set(123, 'i', 3);
$cache->decr(123, 'i');
is $cache->get(123, 'i'), 2, 'decr worked';

done_testing();
