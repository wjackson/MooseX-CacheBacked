package MooseX::CacheBacked::Cache;
use Moose::Role;

requires qw(
    get_attr
    set_attr
);

1;
