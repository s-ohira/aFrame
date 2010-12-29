package jp::coocan::la::estructura::aframe::Logic;

=head1 Summery
/******************************************************************************
 * Name   : Logic.pm
 * Summery: Logic Base Package
 * Author : s-ohira
 * Date   : 2008-06-13
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

use 5.12.0;

BEGIN {
    sub get_prop_list {
        return ['connection'];
    }
}

use Class::XSAccessor {
    accessors => get_prop_list()
};


state $Dao ||= 'jp::coocan::la::estructura::aframe::Dao';


sub new {
    return bless {}, shift;
}

sub dao_factory {
    my ( $this, $dao_name ) = @_;

    my $dao = $dao_name->new();
    $dao->isa($Dao)
        or throw( $this->dao_name() . " must be $Dao" );
    $dao->connection( $this->connection() );

    return $dao;
}

# close DB connection ( if it exists )
DESTROY {
    my $this = shift;
    $this->connection() and $this->connection()->disconnect();
}


1;


__END__