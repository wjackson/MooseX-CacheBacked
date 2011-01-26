package MooseX::CacheBacked::Role;

use Moose::Role;

has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has cache => (
    is       => 'ro',
    does     => 'MooseX::CacheBacked::Cache',
    required => 1,
);

1;
