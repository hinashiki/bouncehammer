# $Id: Smartphone.pm,v 1.1.2.3 2013/08/30 08:51:14 ak Exp $
# Copyright (C) 2011,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::RU::
                                                                        
  #####                        ##          ##                           
 ###     ##  ##  ####  ##### ###### #####  ##      ####  #####   ####   
  ###    ######     ## ##  ##  ##   ##  ## #####  ##  ## ##  ## ##  ##  
   ###   ######  ##### ##      ##   ##  ## ##  ## ##  ## ##  ## ######  
    ###  ##  ## ##  ## ##      ##   #####  ##  ## ##  ## ##  ## ##      
 #####   ##  ##  ##### ##       ### ##     ##  ##  ####  ##  ##  ####   
                                    ##                                  
package Kanadzuchi::Mail::Group::RU::Smartphone;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's smaprtphone domains in Russian Federation
sub communisexemplar { return qr{[.]com\z}; }
sub nominisexemplaria {
    my $class = shift;
    return {
        'beeline' => [
            # Билайн; http://www.beeline.ru/
            qr{\Abeeline[.]blackberry[.]com\z},
        ],
        'mtc' => [
            # MTC; http://www.mts.ru/
            qr{\Amts(?:ru)?[.]blackberry[.]com\z},
        ],
    };
}

1;
__END__
