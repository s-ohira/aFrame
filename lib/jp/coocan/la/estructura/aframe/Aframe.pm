package jp::coocan::la::estructura::aframe::Aframe;

# Freely distributable under MIT-style license.

=head1 Summery
/******************************************************************************
 * Name   : Aframe.pm
 * Summery: base package for application
 * Author : s.ohira
 * Date   : 2008-06-13
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;

use src::ErrorAction;
use Log::Log4perl;

use jp::coocan::la::estructura::aframe::AF;


sub new { return bless {}, shift; }

sub throw {
    my ( $this, $message, $err_code ) = @_;
    $AF::logger and $AF::logger->error( $message );

    my $action = new ErrorAction();
    $action->execute( $message, $err_code );
}


1;


__END__