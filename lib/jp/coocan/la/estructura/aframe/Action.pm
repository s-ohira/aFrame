package jp::coocan::la::estructura::aframe::Action;

=head1 Summery
/******************************************************************************
 * Name   : Action.pm
 * Summery: Action Base Package
 * Author : s-ohira
 * Date   : 2008-06-13
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

use HTML::Template;

use jp::coocan::la::estructura::aframe::Deligate;


sub get_logic {
    my ( $this, $logic_name ) = @_;
    my $deligate = new jp::coocan::la::estructura::aframe::Deligate();
    $deligate->logic_name( $logic_name );
    return $deligate;
}

sub output {
    my ( $this, $request, $tmpl_file ) = @_;

    my $tmpl = new Html::Template(
        'filename'          => $tmpl_file
       ,'die_on_bad_params' => 0
       ,'global_vars'       => 1
    );
    $tmpl->param( $_ => $request->attribute()->$_() )
        for ( keys %{$request->attribute()} );
    $tmpl->output();
}


1;


__END__