# $Id: WebMail.pm,v 1.3.2.3 2013/08/30 08:51:14 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::TW::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::TW::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Republic Of China, Taiwan
sub communisexemplar { return qr{[.]tw\z}; }
sub nominisexemplaria {
    my $class = shift;
    return {
        'kingnet' => [
            # KingNet(Gmail); http://mail.kingnet.com.tw/
            qr{kingnet[.]com[.]tw\z},
        ],
        'seednet' => [
            # http://www.seed.net.tw/
            qr{\Aseed[.]net[.]tw\z},
            qr{\Atpts[1-8][.]seed[.]net[.]tw\z},
            qr{\A(?:venus|mars|saturn|titan|iris|libra|pavo)[.]seed[.]net[.]tw\z},
            qr{\A(?:ara|tcts|tcts1|shts|ksts|ksmail)[.]seed[.]net[.]tw\z},
        ],
    };
}

1;
__END__
