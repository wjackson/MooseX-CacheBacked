package MooseX::CacheBacked::Role::Meta::Instance;

use Moose::Role;
use MooseX::CacheBacked::Cache::Hash;

sub create_instance {
    my $self = shift;
    my $instance = {};
    $instance->{cache} = MooseX::CacheBacked::Cache::Hash->new();

    bless $instance, $self->_class_name;

    return $instance;
}

sub get_slot_value {
    my ( $self, $instance, $slot_name ) = @_;
    return $instance->{cache}->get_attr($slot_name);
}

sub set_slot_value {
    my ( $self, $instance, $slot_name, $value ) = @_;
    $instance->{cache}->set_attr($slot_name, $value);
    return;
}

sub inline_set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;
    return sprintf q{%s->{cache}->set_attr('%s', %s)},
                   $instance,
                   $slot_name,
                   $value;
}

sub inline_get_slot_value {
    my ($self, $instance, $slot_name) = @_;
    return sprintf q{%s->{cache}->get_attr('%s')},
                   $instance,
                   $slot_name;
}

1;
