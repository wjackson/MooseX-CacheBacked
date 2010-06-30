use strict;
use warnings;
use Test::More;
use Moose;

{
    package Class;
    use Moose;
    with 'MooseX::CacheBacked::Cache::Hash';

    has store => (
        is      => 'ro',
        isa     => 'HashRef',
        default => sub { {} },
    );
}

done_testing();
