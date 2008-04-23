#!perl
#
# Author:      Peter J. Acklam
# Time-stamp:  2008-04-18 15:04:40 +02:00
# E-mail:      pjacklam@cpan.org
# URL:         http://home.online.no/~pjacklam

#########################

use 5.006;              # for the 'utf8' and 'warnings' pragmas
use strict;             # restrict unsafe constructs
use warnings;           # control optional warnings

#use utf8;               # enable/disable UTF-8 (or UTF-EBCDIC) in source code

#########################

use Test::More tests => 1;

BEGIN { use_ok('Text::Unaccent::PurePerl'); }

diag("Testing Text::Unaccent::PurePerl $Text::Unaccent::PurePerl::VERSION, Perl $], $^X");

# Emacs Local Variables:
# Emacs coding: iso-8859-1
# Emacs mode: perl
# Emacs End:
