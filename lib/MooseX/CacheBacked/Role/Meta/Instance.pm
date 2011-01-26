package MooseX::CacheBacked::Role::Meta::Instance;

use Moose::Role;

sub create_instance {
    my ($self) = @_;
    my $instance = {};

    $instance->{id}            = undef;
    $instance->{cache}         = undef;
    $instance->{cache_set_cbs} = [];

    return bless $instance, $self->_class_name;
}

#
# Non-inline set_slot_value is called by the contructor (init_args).
#
# Can't persist to cache until id is known.  However, init_args isn't ordered
# so there's no way to guarantee id is processed first.  To addresss this we
# queue cache->set operations until id is available.
#
sub set_slot_value {
    my ( $self, $instance, $slot_name, $value ) = @_;

    # deal w/ special attrs 'id' and 'cache'
    if ($slot_name eq 'id') {
        $instance->{id} = $value;
    }
    if ($slot_name eq 'cache') {
        $instance->{cache} = $value;
    }

    # queue the cache->set
    push @{ $instance->{cache_set_cbs} }, sub {
        $instance->{cache}->set( $instance->{id}, $slot_name, $value );
    };

    # delay the cache->set until id and cache are available
    return if !defined $instance->{id} || !defined $instance->{cache};

    # id and cache are available, execute any pending cache->set operations
    while (my $set_slot_cb = shift @{ $instance->{cache_set_cbs} }) {
        $set_slot_cb->();
    }

    return;
}

sub inline_set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;
    return sprintf q{%s->{cache}->set(%s->{id}, '%s', %s)},
                   $instance,
                   $instance,
                   $slot_name,
                   $value;
}

sub inline_get_slot_value {
    my ($self, $instance, $slot_name) = @_;
    return sprintf q{%s->{cache}->get(%s->{id}, '%s')},
                   $instance,
                   $instance,
                   $slot_name;
}

1;
