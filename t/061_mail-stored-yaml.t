# $Id: 061_mail-stored-yaml.t,v 1.11.2.3 2013/10/21 06:37:07 ak Exp $
#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||L |||i |||b |||r |||a |||r |||i |||e |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
use lib qw(./t/lib ./dist/lib ./src/lib);
use strict;
use warnings;
use Kanadzuchi::Test;
use Kanadzuchi::Test::Mail;
use Kanadzuchi::Mail::Stored::YAML;
use Test::More ( 'tests' => 1434 );

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Y = <DATA>;
my $T = new Kanadzuchi::Test(
    'class' => 'Kanadzuchi::Mail::Stored::YAML',
    'methods' => [ 
        @{ $Kanadzuchi::Test::Mail::MethodList->{'BaseClass'} },
        @{ $Kanadzuchi::Test::Mail::MethodList->{'Stored::YAML'} },
    ],
    'instance' => undef,
);
my $F = './examples/hammer.1970-01-01.ffffffff.000000.tmp';

#  ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||T |||e |||s |||t |||       |||c |||o |||d |||e |||s ||
# ||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
PREPROCESS: {
    my $json = shift @{ JSON::Syck::Load( $Y ) };
    my $destinationd = q();
    my $senderdomain = q();

    isa_ok( $json, 'HASH', 'Loaded data is HASH' );

    ( $destinationd = $json->{'recipient'} ) =~ s{\A.+[@]}{}g;
    ( $senderdomain = $json->{'addresser'} ) =~ s{\A.+[@]}{}g;

    $T->instance(
        new Kanadzuchi::Mail::Stored::YAML(
            'bounced' => $json->{'bounced'},
            'addresser' => ucfirst $json->{'addresser'},
            'recipient' => ucfirst $json->{'recipient'},
            'token' => $json->{'token'},
            'hostgroup' => $json->{'hostgroup'},
            'provider' => $json->{'provider'},
            'description' => $json->{'description'},
            'reason' => $json->{'reason'},
        )
    );

    isa_ok( $T->instance, $T->class );
    can_ok( $T->class, @{ $T->methods } );
}

CHECK_VALUES: {
    my $object = $T->instance;
    my $descrs = {};
    my $sender = q();
    my $destnd = q();

    isa_ok( $object->addresser, 'Kanadzuchi::Address', '->addresser == Kanadzuchi::Address' );
    isa_ok( $object->recipient, 'Kanadzuchi::Address', '->recipient == Kanadzuchi::Address' );
    isa_ok( $object->bounced, 'Time::Piece', '->bounced == Time::Piece' );
    isa_ok( $object->description, 'HASH', '->description == HASH' );

    $sender = $object->addresser->host;
    $destnd = $object->recipient->host;
    $descrs = $object->description;

    is( $object->bounced->epoch, 166222661, 'Epoch of the date' );
    is( $object->bounced->year, 1975, 'Year of the date' );
    is( $object->bounced->month, 'Apr', 'Month name of the date' );

    $object->timezoneoffset( $descrs->{'timezoneoffset'} );
    $object->diagnosticcode( $descrs->{'diagnosticcode'} );

    is( $object->senderdomain, $sender, 'Sender domain = '.$sender );
    is( $object->destination, $destnd, 'Destination host = '.$destnd );
    is( $object->timezoneoffset, '+0900', 'Timezone = +0900' );
    is( $object->diagnosticcode, 'Test record', 'Diagnostic code = '.$descrs->{'diagnosticcode'} );
}

CONSTRUCTORS: {
    my $object = undef;
    my $entity = undef;
    my $reqobj = 0;
    my $jsoned = shift @{ JSON::Syck::Load( $Y ) };
    my $member = [ 
        'addresser', 'recipient', 'senderdomain', 'destination', 'reason', 
        'hostgroup', 'provider', 'token',
    ];
    my $descrp = [ 
        'deliverystatus', 'diagnosticcode', 'timezoneoffset', 'smtpagent', 
        'listid' ];

    LOAD: {

        $reqobj = 0;
        $T->instance( $T->class->load( $Y ) );
        $object = $T->instance;
        $entity = shift @$object;

        isa_ok( $object, 'ARRAY' );
        isa_ok( $entity, 'HASH' );
        isa_ok( $entity->{'description'}, 'HASH', '->description is HASH' );

        foreach my $_m ( @$member ) {
            is( $entity->{ $_m }, $jsoned->{ $_m }, qq|->$_m == $jsoned->{$_m}| );
        }

        foreach my $_d ( @$descrp ) {
            is( $entity->{'description'}->{ $_d }, $jsoned->{'description'}->{ $_d },
                qq|->$_d == $jsoned->{'description'}->${_d}| );
        }
    }

    LOADANDNEW: {

        $T->instance( $T->class->loadandnew( $Y ) );

        $object = $T->instance;
        $entity = $object->next;

        isa_ok( $object, 'Kanadzuchi::Iterator' );
        isa_ok( $entity, $T->class );
        isa_ok( $entity->addresser, 'Kanadzuchi::Address' );
        isa_ok( $entity->recipient, 'Kanadzuchi::Address' );
        isa_ok( $entity->bounced, 'Time::Piece' );
        isa_ok( $entity->description, 'HASH' );

        is( $entity->addresser->address, $jsoned->{'addresser'}, '->addresser->address == '.$jsoned->{'addresser'} );
        is( $entity->recipient->address, $jsoned->{'recipient'}, '->recipient->address == '.$jsoned->{'recipient'} );

        is( $entity->addresser->host, $entity->senderdomain, '->addresser->host == senderdomain' );
        is( $entity->recipient->host, $entity->destination, '->recipient->host == destination' );

        is( $entity->senderdomain, $jsoned->{'senderdomain'}, '->senderdomain == '.$jsoned->{'senderdomain'} );
        is( $entity->destination, $jsoned->{'destination'}, '->destination == '.$jsoned->{'destination'} );

        is( $entity->deliverystatus, '5.3.4', $T->class.'->loadandnew->deliverystatus ' );
        is( $entity->diagnosticcode, 'Test record', $T->class.'->loadandnew->diagnosticcode ' );
        is( $entity->timezoneoffset, '+0900', $T->class.'->loadandnew->timezoneoffset ' );
        is( $entity->smtpagent, 'Sendmail', $T->class.'->loadandnew->smtpagent ' );
        is( $entity->listid, q(), $T->class.'->loadandnew->listid ' );
    }
} # 43

SKIP: {
    my $BdDR = undef;
    my $Skip = 1387;
    my $Btab = undef;
    my $Mtab = {};
    my $Cdat = undef;
    my $Yobj = undef;
    my $Page = undef;
    my $Damn = {};

    eval { require DBI; }; skip( 'Because no DBI for testing', $Skip ) if $@;
    eval { require DBD::SQLite; }; skip( 'Because no DBD::SQLite for testing', $Skip ) if $@;

    require Time::Piece;
    require Kanadzuchi::Test::DBI;
    require Kanadzuchi::BdDR::Page;
    require Kanadzuchi::BdDR::Cache;
    require Kanadzuchi::BdDR;
    require Kanadzuchi::BdDR::BounceLogs;
    require Kanadzuchi::BdDR::BounceLogs::Masters;

    CONNECT: {
        $BdDR = Kanadzuchi::BdDR->new;
        $BdDR->setup( { 'dbname' => ':memory:', 'dbtype' => 'SQLite' } );
        $BdDR->printerror(1);
        $BdDR->connect;

        isa_ok( $BdDR, 'Kanadzuchi::BdDR' );
        isa_ok( $BdDR->handle, 'DBI::db' );
    }

    TABLE_OBJECTS: {
        $Page = Kanadzuchi::BdDR::Page->new;
        $Cdat = Kanadzuchi::BdDR::Cache->new;
        $Btab = Kanadzuchi::BdDR::BounceLogs::Table->new( 'handle' => $BdDR->handle );
        $Mtab = Kanadzuchi::BdDR::BounceLogs::Masters::Table->mastertables( $BdDR->handle );

        isa_ok( $Page, 'Kanadzuchi::BdDR::Page' );
        isa_ok( $Cdat, 'Kanadzuchi::BdDR::Cache' );
        isa_ok( $Btab, 'Kanadzuchi::BdDR::BounceLogs::Table' );

        foreach my $_mt ( keys %$Mtab ) {
            isa_ok( $Mtab->{ $_mt }, 'Kanadzuchi::BdDR::BounceLogs::Masters::Table' );
        }
    }

    DATA_OBJECT: {
        $Yobj = $T->class->loadandnew( $F );
        isa_ok( $Yobj, 'Kanadzuchi::Iterator' );
        is( $Yobj->count, 37, '->count = 37' );
    }

    BUILD_DATABASE: {
        ok( Kanadzuchi::Test::DBI->buildtable( $BdDR->handle ), '->DBI->buildtable' );
    }

    INSERT_AND_UPDATE: {
        my $newid = 0;
        my $ustat = 0;
        my $tstat = 0;
        my $array = [];
        my $entry = {};
        my $freqv = 0;

        while( my $_e = $Yobj->next ) {
            last unless defined $_e;

            FIND_BY_TOKEN1: {
                $tstat = $_e->findbytoken( $Btab, $Cdat );
                is( $tstat, 0, '->findbytoken('.$_e->token.') = 0' );
            }

            UPDATE1: {
                $ustat = $_e->update($Btab,$Cdat);
                is( $ustat, 0, '->update = 0' );
            }

            INSERT: {
                $newid = $_e->insert( $Btab, $Mtab, $Cdat );

                if( $_e->senderdomain eq 'example.org' ) {
                    # The senderdomain 'example.org' does not exist in src/sql/*.sql
                    is( $newid, 0, '->insert, ID = 0(No senderdomain), FROM = '.$_e->addresser->address );

                } else {
                    ok( $newid, '->insert, ID = '.$newid.', FROM = '.$_e->addresser->address );

                    $array = $Btab->search( { 'id' => $newid } );
                    isa_ok( $array, 'ARRAY' );
                    ok( scalar @$array, '->search(id) returns '.scalar( @$array ) );

                    $entry = shift @$array;
                    $freqv = $entry->{'frequency'};
                    isa_ok( $entry, 'HASH' );
                    is( $entry->{'addresser'}, $_e->addresser->address, '->addresser = '.$entry->{'addresser'} );
                    is( $entry->{'recipient'}, $_e->recipient->address, '->recipient = '.$entry->{'recipient'} );
                    is( $entry->{'senderdomain'}, $_e->senderdomain, '->senderdomain = '.$entry->{'senderdomain'} );
                    is( $entry->{'senderdomain'}, $_e->addresser->host, '->senderdomain = addresser->host' );
                    is( $entry->{'destination'}, $_e->destination, '->destination = '.$entry->{'destination'} );
                    is( $entry->{'destination'}, $_e->recipient->host, '->destination = recipient->host' );
                    is( $entry->{'hostgroup'}, $_e->hostgroup, '->hostgroup = '.$entry->{'hostgroup'} );
                    is( $entry->{'provider'}, $_e->provider, '->provider = '.$entry->{'provider'} );
                    is( $entry->{'reason'}, $_e->reason, '->reason = '.$entry->{'reason'} );
                }
            }

            FIND_BY_TOKEN2: {
                $tstat = $_e->findbytoken( $Btab, $Cdat );

                if( $_e->senderdomain eq 'example.org' ) {
                    is( $tstat, 0, '->findbytoken('.$_e->token.') = 0' );

                } else {
                    is( $tstat, 1, '->findbytoken('.$_e->token.') = 1' );
                }
            }

            UPDATE2: {
                $_e->reason('unstable');
                $_e->hostgroup('neighbor');
                $_e->bounced( Time::Piece->new );
                $ustat = $_e->update( $Btab, $Cdat );

                if( $_e->senderdomain eq 'example.org' ) {
                    is( $ustat, 0, '->update('.$_e->token.') = 0; No record in the DB' );

                } else {
                    ok( $ustat, '->update('.$_e->token.')' );

                    $array = $Btab->search( { 'token' => $_e->token } );
                    isa_ok( $array, 'ARRAY' );
                    ok( scalar @$array, '->search('.$_e->token.') returns '.scalar( @$array ) );

                    $entry = shift @$array;
                    isa_ok( $entry, 'HASH' );
                    is( $entry->{'hostgroup'}, 'neighbor', '->hostgroup = neighbor');
                    is( $entry->{'reason'}, 'unstable', '->reason = unstable' );
                    is( $entry->{'frequency'}, $freqv + 1, '->frequency = '.$entry->{'frequency'} );
                }
            }
            next if $_e->senderdomain eq 'example.org';

            UPDATE3: {
                sleep(1);
                $_e->reason('undefined');
                $_e->hostgroup('undefined');
                $_e->bounced( Time::Piece->new );
                $ustat = $_e->update( $Btab, $Cdat );

                ok( $ustat, '->update('.$_e->token.')' );

                $array = $Btab->search( { 'token' => $_e->token } );
                isa_ok( $array, 'ARRAY' );
                ok( scalar @$array, '->search('.$_e->token.') returns '.scalar( @$array ) );

                $entry = shift(@$array);
                isa_ok( $entry, 'HASH' );
                is( $entry->{'hostgroup'}, 'undefined', '->hostgroup = undefined');
                is( $entry->{'reason'}, 'undefined', '->reason = undefined' );
                is( $entry->{'frequency'}, $freqv + 2, '->frequency = '.$entry->{'frequency'} );
            }

            UPDATE4: {
                $_e->reason('onhold');
                $_e->hostgroup('reserved');
                $ustat = $_e->update( $Btab, $Cdat );

                ok( $ustat, '->update('.$_e->token.')' );

                $array = $Btab->search( { 'token' => $_e->token } );
                isa_ok( $array, 'ARRAY' );
                ok( scalar @$array, '->search('.$_e->token.') returns '.scalar( @$array ) );

                $entry = shift @$array;
                isa_ok( $entry, 'HASH' );
                is( $entry->{'hostgroup'}, 'reserved', '->hostgroup = reserved');
                is( $entry->{'reason'}, 'onhold', '->reason = onhold' );
                is( $entry->{'frequency'}, $freqv + 2, '->frequency = '.$entry->{'frequency'} );
            }

            DAMNED: {
                $Damn = $_e->damn;
                isa_ok( $Damn, 'HASH', '->damn' );
            }
        }
    }

}

__DATA__
- { "bounced": 166222661, "addresser": "postmaster@example.jp", "recipient": "very-very-big-message-to-you@gmail.com", "senderdomain": "example.jp", "destination": "gmail.com", "reason": "mesgtoobig", "hostgroup": "webmail", "provider": "google", "description": { "deliverystatus": "5.3.4", "timezoneoffset": "+0900", "diagnosticcode": "Test record", "smtpagent": "Sendmail", "listid": "", "subject": "TEST", "messageid": "<0000@example.org>" }, "token": "aeaaeb939a918caaef3be00f19b66506" }
