package MooseX::CacheBacked::Role::Meta::Instance;

use Moose::Role;
use MooseX::CacheBacked::Cache::Hash;

sub create_instance {
    my ($self) = @_;
    my $instance = {};
    $instance->{cache} = MooseX::CacheBacked::Cache::Hash->new();

    return bless $instance, $self->_class_name;
}

#
# Non-inline set_slot_value get's called by the contructor (init_args)...
#
# Can't store in cache until id is set.  However, order of init_args is
# essentially random so there's no way to guarantee that the id is processed
# first.  Need to store up a list of pending cache updates until id gets set.
sub set_slot_value {
    my ( $self, $instance, $slot_name, $value ) = @_;

    my $cache = $instance->{cache};

    if ($slot_name eq 'id') {
        my $id = $value;
        $instance->{id} = $id;

        # store any queued attributes from before the id attr was available...
        if (exists $instance->{qd_slot_names}) {

            for my $qd_slot_name (keys %{ $instance->{qd_slot_names} }) {
                my $qd_value  = $instance->{qd_slot_names}->{$qd_slot_name};
                $cache->set($id, $qd_slot_name, $qd_value);
            }

            delete $instance->{qd_slot_names};
        }
    }

    # id attr has not yet been set so q up the attr/value for later...
    if (!exists $instance->{id}) {
        $instance->{qd_slot_names}->{$slot_name} = $value;
        return;
    }

    $cache->set($instance->{id}, $slot_name, $value);

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
