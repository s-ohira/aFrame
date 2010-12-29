package src::dao::TestDao;

use strict;
use warnings;

use parent qw(jp::coocan::la::estructura::aframe::Dao);

use Data::Section::Simple qw(get_data_section);


sub retrieve_enable_list {
    my $this = shift;
    my $query = get_data_section('select_enable_date');

    my $result_list =  $this->execute( $query, [], [] );
    return $result_list->[0][0];
}


1;


__DATA__

@@ select_enable_date
select * from fuge
 where CURDATE() between start_date and end_date;

@@ end


__END__


