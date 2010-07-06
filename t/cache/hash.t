use strict;
use warnings;
use Test::More;
use MooseX::CacheBacked::Cache::Hash;

my $cache = MooseX::CacheBacked::Cache::Hash->new();

$cache->set(123, 'foo', 'bar');
is $cache->get(123, 'foo'), 'bar', 'get/set cache value';

done_testing();
