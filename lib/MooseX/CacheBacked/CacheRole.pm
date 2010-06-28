package MooseX::CacheBacked::CacheRole;
use Moose::Role;

requires qw(
    id
    get_attr
    set_attr
);

1;
