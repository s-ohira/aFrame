package jp::coocan::la::estructura::aframe::Deligate;

# Freely distributable under MIT-style license.

=head1 Summery
/******************************************************************************
 * Name   : Deligate.pm
 * Summery: Transaction Management Package
 * Author : s-ohira
 * Date   : 2008-06-14
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

use Const::Fast;


BEGIN {
    sub get_prop_list {
        return ['logic_name' ];
    }
}

use Class::XSAccessor {
    accessors => get_prop_list()
};


state $Logic ||= 'jp::coocan::la::estructura::aframe::Logic';


sub new {
    return bless {}, shift;
}


AUTOLOAD {
    my ( $this, @args ) = @_;
    my $method_name = our $AUTOLOAD;
    $method_name =~ s/.*:://;

    my $logic = $this->logic_name()->new();
    $logic->isa( $Logic )
        or $this->throw( $this->logic_name() . " must be $Logic" );
    $logic->can( $method_name )
        or $this->throw( "not found $AUTOLOAD" );

    my $connection = DBI->connect( 
        'DBI:' . $AF::conf{'DB_CONF'}->{'sql'} . ':'
            . $AF::conf{'DB_CONF'}->{'path'}
       ,$AF::conf{'DB_CONF'}->{'acount'}
       ,$AF::conf{'DB_CONF'}->{'pass'}
       ,{ PrintError => 1, raiseError => 1, AutoCommit => 0 }
    );

    $logic->connection( $connection );
    $AF::conf{'TX'} and $connection->do( 'BEGIN' );
    $logic->$method_name( @args );
    $AF::conf{'TX'} and $this->connetion->errstr
            ? $connection->do( 'ROLLBACK' )
            : $connection->do( 'COMMIT'   );
    $logic->connection()->disconnect();
}

DESTROY {
}


1;


__END__