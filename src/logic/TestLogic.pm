package src::logic::TestLogic;

use strict;
use warnings;

use parent qw(jp::coocan::la::estructura::aframe::Logic);

use src::dao::TestDao;


sub retrieve_date {
    my $this = shift;
    my $dao = $this->dao_factory('src::dao::TestDao');
    return $dao->retrieve_enable_list();
}


1;
