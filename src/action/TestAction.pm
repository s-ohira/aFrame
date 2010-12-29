package src::action::TestAction;

use strict;
use warnings;

use base qw(jp::coocan::la::estructura::aframe::Action);

use src::logic::TestLogic;


# アプリの一覧を取得する
sub doList {
    my ( $this, $form, $request ) = @_;

    # 入力画面を表示する
    my $logic = $this->get_logic( 'src::logic::TestLogic' );
    $logic->retrieve_date();
}


1;
