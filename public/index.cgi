#!/usr/bin/perl

=head1
/******************************************************************************
 * Name   : index.cgi
 * Summery: main script
 * Author : s-ohira
 * Date   : 2009-12-14
 *****************************************************************************/
=cut

use strict;
use warnings;
use lib qw(../ ../lib ../lib/CPAN ../lib/Digest);
use base qw(jp::coocan::la::estructura::aframe::Aframe);

BEGIN {
    #---↓↓↓ user setting ↓↓↓---#
    require '../lib/jp/coocan/la/estructura/aframe/AF.pm';

    # constants config file
    $AF::conf{'APPS_CONST' }    ||= '../resources/conf/const.yml';
    # application config file
    $AF::conf{'APPS_CONF'  }    ||= '../resources/conf/conf.yml';
    # database config file
    $AF::conf{'DB_CONFIG'  }    ||= '../resources/conf/db-conf.yml';
    # log4perl config file
    $AF::conf{'LOGGER_CONF'}    ||= '../resources/conf/log4perl.conf';
    # output charaset
    $AF::conf{'charset'    }    ||= 'UTF-8';
    # tranzaction management(0:OFF 1:ON)
    $AF::conf{'TX'         }    ||= 0;
    #---↑↑↑ user setting ↑↑↑---#
    require '../lib/jp/coocan/la/estructura/aframe/RequestProcessor.pm';
}


#---↓↓↓ user_application if ( you_need ) ↓↓↓---#
#---↑↑↑ user_application if ( you_need ) ↑↑↑---#

#---↓↓↓ Don't touch here!! ↓↓↓---#
jp::coocan::la::estructura::aframe::RequestProcessor->new()->do_process();
#---↑↑↑ Don't touch here!! ↑↑↑---#


#---↓↓↓ user_application if ( you_need ) ↓↓↓---#
#---↑↑↑ user_application if ( you_need ) ↑↑↑---#


__END__
