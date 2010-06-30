package MooseX::CacheBacked;
use strict;
use warnings;
use Carp qw(confess);
use Moose::Exporter;

our $VERSION = '0.01';
use 5.10.0;

Moose::Exporter->setup_import_methods(
    with_meta => ['has'],
);

sub has {
    my ($meta, $name, %options) = @_;

    if ($name eq 'id') {
        $meta->add_attribute($name, %options);
        return;
    }

    _verify_role($meta);

    my $reader      = $options{reader}      // $name;
    my $writer      = $options{writer}      // qq{$name};
    my $initializer = $options{initializer} // qq{init_$name};
    $options{initializer} //= $initializer;

    $meta->add_attribute($name, %options);

    # make reader / writer / accesor use the backend cache...
    my $accessor = sub { _attr_accessor(@_, $name) };
    $meta->add_method( $reader      => $accessor );
    $meta->add_method( $writer      => $accessor );
    $meta->add_method( $initializer => $accessor );

    return;
}

# insist that the meta class consume MooseX::CacheBackend::Cache...
sub _verify_role {
    my ($meta) = @_;

    my $cache_role = 'MooseX::CacheBacked::Cache';
    my $class_name = $meta->name;
    confess qq{class '$class_name' must consume $cache_role}
        if !$meta->does_role($cache_role);
    return;
}

# dispatch
sub _attr_accessor {
    return _attr_reader(@_)      if @_ == 2; # reader
    return _attr_writer(@_)      if @_ == 3; # writer
    return _attr_initializer(@_) if @_ == 5; # initializer
    confess q{Wrong number of args};
}

sub _attr_reader {
    my ($self, $name) = @_;
    return $self->get_attr($name);
}

sub _attr_writer {
    my ($self, $value, $name) = @_;
    $self->set_attr($name, $value);
    return;
}

sub _attr_initializer {
    my ($self, $value, $set, $attr, $name) = @_;
    $self->set_attr($name, $value);
    return;
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
