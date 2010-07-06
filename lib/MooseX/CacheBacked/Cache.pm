package MooseX::CacheBacked::Cache;
use Moose::Role;

requires qw(
    get
    set
);

1;
