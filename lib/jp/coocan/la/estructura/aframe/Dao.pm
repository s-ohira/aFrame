package jp::coocan::la::estructura::aframe::Dao;

# Freely distributable under MIT-style license.

=head1 Summery
/******************************************************************************
 * Name   : jp::coocan::la::estructura::aframe::Dao
 * Summery: Dao Base Package
 * Author : s-ohira
 * Date   : 2008-06-15
 ******************************************************************************/
=cut

use 5.12.0;
use utf8;
use parent qw(jp::coocan::la::estructura::aframe::Aframe);

use LWP;
use LWP::UserAgent;
use Const::Fast;
use HTTP::Request::Common qw(GET POST);


BEGIN {
    sub get_prop_list {
        return [ 'connection', 'is_error', 'err_mes' ];
    }
}

use Class::XSAccessor {
    accessors => get_prop_list()
};


state $Logic ||= 'jp::coocan::la::estructura::aframe::Logic';
my $logger = Log::Log4perl::get_logger('logger1');


sub new {
    return bless {}, shift;
}

sub callback {
    my ( $this, $result_set, $col_list ) = @_;

    my $result_list = [];
    map {
        my $entity_map = {};
        @{ $entity_map }{ @$col_list } = @$_;
        push @$result_list, $entity_map;
    } @$result_set;

    return $result_list;
}

sub fetch {
    my ( $this, $query, $param_list, $col_list ) = @_;

    my $sth = $this->connection()->prepare( $query );
    if ( defined $param_list ) {
        for my $i ( 1..int @$param_list ) {
            $sth->bind_param( $i, $param_list->[$i] );
        }
    }

    $sth->execute( @$param_list ) or $this->is_error(1);
    if ( $this->is_error() ) {
        $this->err_mes( $this->connection()->errstr );
        $logger->error(
                $this->connection()->errstr
                . $query
                . join q{, }, @$param_list
            );
        return undef;
    }
    if ( my $result_list = $sth->fetchrow_arrayref() ) {
        if ( $col_list && @$col_list ) {
            my $entity_map = {};
            @{ $entity_map }{ @$col_list } = @$result_list;
            return $entity_map;
        }

        return @$result_list ? $result_list
                             : undef;
    }
}

sub execute {
    my ( $this, $query, $param_list, $col_list ) = @_;

    my $result_list = [];

    my $sth = $this->connection()->prepare( $query ) or $this->is_error(1);
    $this->is_error() and $this->err_mes( $this->connection()->errstr ) and return;

    if ( defined $param_list ) {
        for my $i ( 1..int @$param_list ) {
            $sth->bind_param( $i, $param_list->[$i] ) or $this->is_error(1);

            if ( $this->is_error() ) {
                $this->err_mes( $this->connection()->errstr );
                $logger->error(
                        $this->connection()->errstr
                            . $query
                            . join q{, }, @$param_list
                    );
                return undef;
            }
        }
    }

    $sth->execute( @$param_list ) or $this->is_error(1);
    if ( $this->is_error() ) {
        $this->err_mes( $this->connection()->errstr );
        $logger->error(
                $this->connection()->errstr
                . $query
                . join q{, }, @$param_list
            );
        return undef;
    }
    while ( my @line = $sth->fetchrow_array() ) {
        push @$result_list, [ @line ];
    }
    if ( defined $col_list and @$col_list ) {
        return $this->callback( $result_list, $col_list )
    }	

    return $result_list;
}

sub execute_update {
    my ( $this, $query, $param_list ) = @_;

    my $rows = 0;

    my $sth = $this->connection()->prepare( $query ) or $this->is_error(1);
    $this->is_error() and $this->err_mes( $this->connection()->errstr ) and return;

    if ( defined $param_list ) {
        for my $i ( 1..int @$param_list ) {
            $sth->bind_param( $i, $param_list->[$i - 1] ) or $this->is_error(1);
            if ( $this->is_error() ) {
                $this->err_mes( $this->connection()->errstr );
                $logger->error(
                        $this->connection()->errstr
                            . $query
                            . join q{, }, @$param_list
                    );
                return undef;
            }
        }
    }

    $rows = $sth->execute() or $this->is_error(1);
    if ( $this->is_error() ) {
        $this->err_mes( $this->connection()->errstr );
        $logger->error(
                $this->connection()->errstr
                . $query
                . join q{, }, @$param_list
            );
        return;
    }

    return $rows;
}

sub batch_execute {
    my ( $this, $query, $param_list ) = @_;

    my $rows = 0;

    my $sth = $this->connection()->prepare( $query ) or $this->is_error(1);
    $this->is_error() and $this->err_mes( $this->connection()->errstr ) and return;

    if ( defined $param_list ) {
        for my $i ( 1..int @$param_list ) {
            my $list = $param_list->[$i - 1];
            for my $j ( 1..int @$list ) {
                $sth->bind_param( $j, $list->[$j - 1] ) or $this->is_error(1);
                if ( $this->is_error() ) {
                    $this->is_error() and $this->err_mes( $this->connection()->errstr );
                    $logger->error(
                        $this->connection()->errstr
                            . $query
                            . join q{, }, @$param_list
                        );
                    return undef;
                }
            }

            $rows += $sth->execute() or $this->is_error(1);
            $this->is_error() and $this->err_mes( $this->connection()->errstr ) and return;
            if ( $this->is_error() ) {
                $this->is_error() and $this->err_mes( $this->connection()->errstr );
                $logger->error(
                    $this->connection()->errstr
                        . $query
                        . join q{, }, @$param_list
                    );
                return undef;
            }
        }
    }

    return $rows;
}

sub open_file {
    
}

sub close_file {
    
}

sub get_access {
    my ( $this, $url, $data ) = @_;

    my $request  = GET( $url, %$data );
    my $res = LWP::UserAgent->new()->request( $request );
    if ( $res->is_success() ) {
        return $res->content();
    }
    else {
        $this->is_error(1);
        return undef;
    }
}

sub post_access {
    my ( $this, $url, $data ) = @_;

    my $request  = POST( $url, [%$data] );
    my $res     = LWP::UserAgent->new()->request( $request );
    if ( $res->is_success() ) {
        return $res->content();
    }
    else {
        $this->is_error(1);
        return undef;
    }
}


1;


__END__
