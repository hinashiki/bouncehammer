# $Id: Dispatch.pm,v 1.2.2.1 2013/08/29 11:02:53 ak Exp $
# -Id: Index.pm,v 1.1 2009/08/29 09:30:33 ak Exp -
# -Id: Index.pm,v 1.3 2009/08/13 07:13:57 ak Exp -
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::API::HTTP::
                                                     
 ####     ##                       ##        ##      
 ## ##         ##### #####  #### ###### #### ##      
 ##  ##  ###  ##     ##  ##    ##  ##  ##    #####   
 ##  ##   ##   ####  ##  ## #####  ##  ##    ##  ##  
 ## ##    ##      ## ##### ##  ##  ##  ##    ##  ##  
 ####    #### #####  ##     #####   ### #### ##  ##  
                     ##                              
package Kanadzuchi::API::HTTP::Dispatch;
use strict;
use warnings;
use base 'CGI::Application::Dispatch';

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Settings = {
    'coreconfig'=> '__KANADZUCHIETC__/bouncehammer.cf',
    'webconfig' => '__KANADZUCHIETC__/webui.cf',
};

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||D |||i |||s |||p |||a |||t |||c |||h |||       |||T |||a |||b |||l |||e ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
my $DispatchTables = [
    'empty' => { 
        'app' => 'API::HTTP', 
        'rm'  => 'Empty',
    },
    'query/:pi_identifier?' => {    # Backward compatible, use 'select'
        'app' => 'API::HTTP::Select',
        'rm'  => 'Select',
    },
    'select/:pi_identifier?' => {
        'app' => 'API::HTTP::Select',
        'rm'  => 'Select',
    },
    'search/:pi_column/:pi_string' => {
        'app' => 'API::HTTP::Search',
        'rm'  => 'Search',
    },
];

my $DispatchArgsToNew = {
    'TMPL_PATH' => [],
    'PARAMS' => {
        'cf' => $Settings->{'coreconfig'},
        'wf' => $Settings->{'webconfig'},
    },
};

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||I |||n |||s |||t |||a |||n |||c |||e |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub dispatch_args {
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+
    # |d|i|s|p|a|t|c|h|_|a|r|g|s|
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+
    # 
    # @Description  CGI::Application::Dispatch::dispatch_args()
    #
    return {
        'prefix' => 'Kanadzuchi',
        'default' => 'empty',
        'table' => $DispatchTables,
        'args_to_new' => $DispatchArgsToNew,
    };
}

1;
__END__
