# $Id: WebMail.pm,v 1.1.2.3 2013/08/30 08:51:14 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::PT::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::PT::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in République Française/French Republic
# sub communisexemplar { return qr{[.]fr\z}; }
sub nominisexemplaria {
    my $class = shift;
    return {
        'sapo' => [
            # SAPO - Portugal Online!; http://www.sapo.pt/ 
            qr{\Asapo[.]pt\z},
        ],
    };
}

1;
__END__
