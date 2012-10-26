package MooseX::CacheBacked::Role::Meta::Attribute;

use Moose::Role;

has incr => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

around install_accessors => sub {
    my ($orig, $self, @args) = @_;

    if ($self->incr) {
        my $attr_name   = $self->name;
        my $incr_method = "incr_$attr_name";
        my $decr_method = "decr_$attr_name";

        $self->associated_class->add_method($incr_method => sub {
            my ($self) = @_;
            return $self->{cache}->incr($self->id, $attr_name);
        });

        $self->associated_class->add_method($decr_method => sub {
            my ($self) = @_;
            return $self->{cache}->decr($self->id, $attr_name);
        });
    }

    return $self->$orig(@args);
};

1;
