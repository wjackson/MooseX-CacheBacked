package MooseX::CacheBacked::Cache;
use Moose::Role;

requires qw(
    get
    set
    incr
    decr
);

sub _key {
    my ($self, $id, $attr) = @_;

    confess q{Argument 'id' isn't defined}   if !defined $id;
    confess q{Argument 'attr' isn't defined} if !defined $attr;

    return $id . ':' . $attr;
}

1;
