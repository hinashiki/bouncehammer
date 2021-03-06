# $Id: WebMail.pm,v 1.2.2.5 2013/08/30 08:51:14 ak Exp $
# Copyright (C) 2010,2012-2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::IN::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::IN::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in India
sub nominisexemplaria {
    my $class = shift;
    return {
        'ibibo' => [
            # http://www.ibibo.com/
            qr{\Aibibo[.]com\z},
        ],
        'in.com' => [
            # in.com; http://mail.in.com/
            qr{\Ain[.]com\z}
        ],
        'india.com' => [
            # http://www.india.com/
            qr{\A(?:zmail|timepass|imail|india|tadka|indiawrites|dvaar|takdhinadhin)[.]com\z},
        ],
        'rediff.com' => [
            # rediff.com; http://www.rediff.com/
            qr{\Arediffmail[.]com\z},
        ],
    };
}

1;
__END__
