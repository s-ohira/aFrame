package jp::coocan::la::estructura::aframe::HttpRequest;

# Freely distributable under MIT-style license.

=head1 Summery
/******************************************************************************
 * Name   : HttpRequest.pm
 * Summery: user request class
 * Author : s-ohira
 * Date   : 2008-06-14
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);


BEGIN {
    sub get_prop_list {
        return [ 'attribute', 'parameter', 'path_info', 'session', 'constants' ];
    }
}

use Class::XSAccessor {
    accessors => get_prop_list()
};


sub new {
    return bless {}, shift;
}


1;


__END__