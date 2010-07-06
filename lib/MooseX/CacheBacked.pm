package MooseX::CacheBacked;
use strict;
use warnings;

our $VERSION = '0.01';
use 5.10.0;
use Carp qw(confess);

use Moose::Exporter;

Moose::Exporter->setup_import_methods();

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

    return $caller->meta();
}

1;

__END__

=head1 NAME

MooseX::CacheBacked - back class attributes in a cache

=head1 SYNOPSIS

    package MyClass;
    use Moose;
    use MooseX::CacheBacked;

    with qw(
        MooseX::CacheBacked::Cache
        MooseX::CacheBacked::Cache::Hash
    );

    has color => ( is => 'rw', isa => 'Str' );

    # later...

    my $c = MyClass->new(id => '123', color => 'blue');

    my $store = $c->store();

=head1 DESCRIPTION

Attribute accessors are automatically setup so that when the value of an
attribute is set a corresponding value in the cache gets set also.
