package MooseX::CacheBacked;
use strict;
use warnings;

our $VERSION = '0.01';
use 5.10.0;
use Carp qw(confess);
use Moose ();

use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    also => 'Moose',
);

sub init_meta {
    my (undef, %args) = @_;

    my $caller = $args{for_class};

    Moose->init_meta(%args);

    Moose::Util::MetaRole::apply_metaroles(
        for => $caller,
        class_metaroles => {
            instance => [ 'MooseX::CacheBacked::Role::Meta::Instance' ],
        },
    );

    Moose::Util::ensure_all_roles($caller, 'MooseX::CacheBacked::Role');

    return $caller->meta();
}

1;

__END__

=head1 NAME

MooseX::CacheBacked - back class attributes in a cache

=head1 SYNOPSIS

    package Shirt;
    use Moose;
    use MooseX::CacheBacked;

    has id    => ( is => 1, isa => 'Str', required => 1 ); # must exist

    has color => ( is => 'rw', isa => 'Str' );
    has size  => ( is => 'ro', isa => 'Int' );

    # later...

    my $c = Shirt->new(id => '123', color => 'blue', size => 5);

    # inside cache:
    #     123:id    =>  123
    #     123:color =>  blue
    #     123:size  =>  5

    $c->color('yellow');

    # inside cache:
    #     123:color => 'yellow'

=head1 DESCRIPTION

Usually Moose uses a blessed hash for the low level storage of attribute
values. MooseX::CacheBacked uses a Cache instead.  Each object's
attribute/value combinations becomes a key/value pair in the cache.  The cache
key is a combination of the objects id and the attribute name.  For this
reason, MooseX::CacheBacked classes should require an attribute called id that
is unique in the context that the object is used.

Whenever a MooseX::Cache attribute is set (via init_arg via the writer method)
the corresponding value in the cache is imediately adjusted.

Newly instanciated MooseX::Cache object automatically have their attributes
set to the values of any previously instanciated objects with the same id.

    my $x = Some::MooseX::Cache::Class->new(id => 7);
    
    $x->size(14);
    $x->color('green');
    $x->material('silk');

    # This could be in another processes that has access to the cache
    my $y = Some::MooseX::Cache::Class->new(id => 7);
    $y->size;  # 14
    $y->color; # 'green'
    $y->material('wool');

    $x->material; # wool

=cut
