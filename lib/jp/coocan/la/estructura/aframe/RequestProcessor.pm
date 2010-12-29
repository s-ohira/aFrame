package jp::coocan::la::estructura::aframe::RequestProcessor;

=head1 Summery
/******************************************************************************
 * Name   : RequestProcessor.pm
 * Purpose: Dispacher Package
 * Author : s-ohira
 * Date   : 2008-06-12
 * Update : 2009-11-10
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

use CGI;
use DBI;
use List::Util qw(first);
use Hash::Util qw(lock_keys);
use HTML::Template::Pro;
use YAML::XS;
use Const::Fast;
use Log::Log4perl qw(get_logger :levels);

use jp::coocan::la::estructura::aframe::HttpRequest;


state $Action = 'jp::coocan::la::estructura::aframe::Action';
state $Form   = 'jp::coocan::la::estructura::aframe::ActionForm';

BEGIN {
    Log::Log4perl::init_once( $AF::conf{'LOGGER_CONF'} );

    my $app_conf_list      = YAML::XS::LoadFile( $AF::conf{'APPS_CONF' } );
    $AF::conf{'CONST'  } ||= YAML::XS::LoadFile( $AF::conf{'APPS_CONST'} );
    $AF::conf{'DB_CONF'} ||= YAML::XS::LoadFile( $AF::conf{'DB_CONFIG' } );

    my $apps_conf_map
        = first{ $ENV{'PATH_INFO'} =~ /^$_->{'path'}/ } @{ $app_conf_list };
    exists $apps_conf_map->{'action'} and my_import( $apps_conf_map->{'action'} );
    exists $apps_conf_map->{'form'  } and my_import( $apps_conf_map->{'form'  } );
    exists $apps_conf_map->{'form'  }
        or my_import( $Form );
    my $action_name
        = exists $apps_conf_map->{'action'} && $apps_conf_map->{'action'};
    my $method_name
        = exists $apps_conf_map->{'method'} && $apps_conf_map->{'method'};
    my $form_name
        = exists $apps_conf_map->{'form'  } && $apps_conf_map->{'form'  };
    my $content_type
        = exists $apps_conf_map->{'form'  } ? $apps_conf_map->{'content_type'}
        :                                     'text/html';

    sub get_apps_conf_map {
        return $apps_conf_map;
    }

    sub get_action_name {
        return $action_name || undef;
    }

    sub get_method_name {
        return $method_name || undef;
    }

    sub get_form_name {
        return $form_name   || $Form;
    }

    sub get_content_type {
        return $content_type   || $Form;
    }

    sub my_import {
        my $mod = shift;
        $mod or return;
        $mod =~ s!::!/!g;
        require "${mod}.pm";
    }
}

sub do_process {
    my $this = shift;

    my $q = new CGI();
    my $PARAM_MAP = {};
    const $PARAM_MAP->{ $_ } => $q->param( $_ ) for ( $q->param() );

    my $temp = $ENV{'PATH_INFO'};
    $temp    =~ s/["'`<>\r\n\t]//g;
    const my $PATH_INFO_LIST => [ split( /\//, $temp ) ];

    get_action_name() // $this->throw( 
            'Not found action setting.'
           ,'E0001'
        );

    my $action = get_action_name()->new();
    $action->isa( $Action )
        or $this->throw(
            get_action_name()
            . " must be ${Action}."
           ,'E0002'
        );

    my $form = get_form_name()->new();
    $form->isa( $Form )
        or $this->throw(
            get_form_name() . " must be ${Form}."
           ,'E0003'
        );
    $form and $form->initialize(
        $PARAM_MAP, $form->get_prop_list() );

    my $request = new jp::coocan::la::estructura::aframe::HttpRequest();
    $request->attribute( {}              );
    $request->parameter( $PARAM_MAP      );
    $request->path_info( $PATH_INFO_LIST );

    my $method_name = get_method_name();
    $action->$method_name( $form, $request );

    my $template = new HTML::Template(
        'filename'          => get_apps_conf_map()->{'tmpl'}
       ,'die_on_bad_params' => 0
       ,'loop_context_vars' => 1
       ,'global_vars'       => 1
    );

    VIEW: {
        my $content_type = get_content_type();
        print "Content-type: $content_type; charset=$AF::conf{'charset'}\n\n";
        for my $key ( keys %{$request->{'attribute'}} ) {
            $template->param( $key, $request->{'attribute'}->{ $key } );
        }
        print $template->output(); 
    }

    return;
}


1;


__END__