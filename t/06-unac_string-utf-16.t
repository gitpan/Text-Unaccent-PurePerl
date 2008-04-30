#!perl
#
# Author:      Peter J. Acklam
# Time-stamp:  2008-04-29 17:28:25 +02:00
# E-mail:      pjacklam@cpan.org
# URL:         http://home.online.no/~pjacklam

#########################

use 5.006;              # for the 'utf8' and 'warnings' pragmas
use strict;             # restrict unsafe constructs
use warnings;           # control optional warnings

#use utf8;               # enable/disable UTF-8 (or UTF-EBCDIC) in source code

use lib 't';

#########################

#use Text::Unaccent;
use Text::Unaccent::PurePerl;

#########################

eval { require Encode; };

if ($@) {
    print "1..0 # skipped because the 'Encode' module is not installed.\n";
    exit;
}

#########################

my $data =
  [
   [
    "\x00n\x00a\x00\xEF\x00v\x00e",
    "\x00n\x00a\x00i\x00v\x00e",
   ],
   [
    "\x00d\x00\xE9\x00j\x00\xE0\x00 \x00v\x00u",
    "\x00d\x00e\x00j\x00a\x00 \x00v\x00u",
   ],
   [
    "\x00E\x00s\x00p\x00a\x00\xF1\x00a",
    "\x00E\x00s\x00p\x00a\x00n\x00a",
   ],
   [
    "\x00F\x00r\x00a\x00n\x00\xE7\x00a\x00i\x00s",
    "\x00F\x00r\x00a\x00n\x00c\x00a\x00i\x00s",
   ],
   [
    "\x00C\x00i\x00t\x00r\x00o\x00\xEB\x00n",
    "\x00C\x00i\x00t\x00r\x00o\x00e\x00n",
   ],
   [
    "\x00N\x00j\x00\xE5\x00l\x00 \x00S\x00\xE6\x00b\x00\xF8",
    "\x00N\x00j\x00a\x00l\x00 \x00S\x00a\x00e\x00b\x00o",
   ],
   [
    "\x03\x95\x03\xBB\x03\xBB\x03\xAC\x03\xB4\x03\xB1",
    "\x03\x95\x03\xBB\x03\xBB\x03\xB1\x03\xB4\x03\xB1",
   ],
   [
    "\x04 \x04C\x04A\x04A\x04:\x048\x049",
    "\x04 \x04C\x04A\x04A\x04:\x048\x048",
   ],
  ];

print "1..8\n";

my $testno = 0;

for (my $i = 0 ; $i <= $#$data ; ++ $i) {
    ++ $testno;

    my $in           = $data->[$i][0];
    my $out_expected = $data->[$i][1];

    my $out_actual   = unac_string_utf16($in);

    unless (defined $out_actual) {
        print "not ok ", $testno, "\n";
        print "  input ......: ", TestUtil::nice_string($in), "\n";
        print "  got ........: <UNDEF>\n";
        print "  expected ...: ", TestUtil::nice_string($out_expected), "\n";
        print "  error ......: the output is undefined\n";
        next;
    }

    unless ($out_actual eq $out_expected) {
        print "not ok ", $testno, "\n";
        print "  input ......: ", TestUtil::nice_string($in), "\n";
        print "  got ........: ", TestUtil::nice_string($out_actual), "\n";
        print "  expected ...: ", TestUtil::nice_string($out_expected), "\n";
        print "  error ......: the actual output is not identical to",
          " the expected output\n";
        next;
    }

    print "ok ", $testno, "\n";

}

# Emacs Local Variables:
# Emacs coding: iso-8859-1
# Emacs mode: perl
# Emacs End:
