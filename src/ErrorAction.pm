package ErrorAction;

use 5.12.0;
use Log::Log4perl;


my $logger = Log::Log4perl::get_logger( 'mylogger' );


sub new {
    return bless {}, shift;
}

sub execute {
    my ( $this, $err_mes, $err_cd ) = @_;
    $err_mes ||= 'unexpected error occured';
    $err_cd  ||= 'unknown';
    $logger->error( $err_mes );

    print "Content-type: text/html; charset=utf-8\n\n";
    print <<"__HTML__";
<html>
<head>
<title>$err_mes</title>
</head>
<body>
$err_cd：$err_mes
</body>
</html>
__HTML__

    exit(1);
}


1;