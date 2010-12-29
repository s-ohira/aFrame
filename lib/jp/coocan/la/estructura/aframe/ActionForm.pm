package jp::coocan::la::estructura::aframe::ActionForm;

# Freely distributable under MIT-style license.

=head1 Summery
/******************************************************************************
 * Name   : ActionForm.pm
 * Summery: Form Base Package
 * Author : s-ohira
 * Date   : 2008-06-15
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

BEGIN {
    sub get_prop_list {
        return [];
    }
}

use Class::XSAccessor {
    accessors => get_prop_list()
};


sub new {
    return bless {}, shift;
}

sub initialize {
    my ( $this, $attribute_map, $PROP_LIST ) = @_;
    $this->$_( $attribute_map->{$_} ) for ( @$PROP_LIST );
}


1;


__END__