#!perl
#
# Author:      Peter J. Acklam
# Time-stamp:  2008-04-23 16:17:22 +02:00
# E-mail:      pjacklam@cpan.org
# URL:         http://home.online.no/~pjacklam

#########################

use 5.006;              # for the 'utf8' and 'warnings' pragmas
use strict;             # restrict unsafe constructs
use warnings;           # control optional warnings

#use utf8;               # enable/disable UTF-8 (or UTF-EBCDIC) in source code

#use Text::Unaccent;
use Text::Unaccent::PurePerl;

#########################

eval { require Encode; };

if ($@) {
    print "1..1\n";
    print "ok  # skipping because the 'Encode' module is not installed.\n";
    exit;
}

#########################

sub nice_string {
    my $str_in  = $_[0];
    my $length  = length($str_in);
    my $str_out = '';

    for (my $offset = 0 ; $offset < $length ; ++ $offset) {
        my $chr = substr($str_in, $offset, 1);
        my $ord = ord($chr);
        $str_out .= $ord > 255 ?                  # if wide character...
                    sprintf("\\x{%04X}", $ord) :  # \x{...}
                    $chr =~ /[^[:print:]]/ ?      # else if non-printable ...
                    sprintf("\\x%02X", $ord) :    # \x..
                    $chr                          # else as is
    }

    return $str_out;
}

#########################

my $data =
  [

   ['ASCII',
    [
     ["",
      "",
     ],
     ["naive",
      "naive",
     ],
     ["deja vu",
      "deja vu",
     ],
     ["Espana",
      "Espana",
     ],
     ["Francais",
      "Francais",
     ],
     ["Citroen",
      "Citroen",
     ],
    ],
   ],

   ['ISO-8859-1',
    [
     ["",
      "",
     ],
     ["d\xE9j\xE0 vu",
      "deja vu",
     ],
     ["Espa\xF1a",
      "Espana",
     ],
     ["Fran\xE7ais",
      "Francais",
     ],
     ["Citro\xEBn",
      "Citroen",
     ],
     ["Nj\xE5l S\xE6b\xF8",
      "Njal Saebo",
     ],
    ],
   ],

   ['UTF-8',
    [
     ["",
      "",
     ],
     ["na\xC3\xAFve",
      "naive",
     ],
     ["d\xC3\xA9j\xC3\xA0 vu",
      "deja vu",
     ],
     ["Espa\xC3\xB1a",
      "Espana",
     ],
     ["Fran\xC3\xA7ais",
      "Francais",
     ],
     ["Citro\xC3\xABn",
      "Citroen",
     ],
     ["Nj\xC3\xA5l S\xC3\xA6b\xC3\xB8",
      "Njal Saebo",
     ],
     ["\xCE\x95\xCE\xBB\xCE\xBB\xCE\xAC\xCE\xB4\xCE\xB1",
      "\xCE\x95\xCE\xBB\xCE\xBB\xCE\xB1\xCE\xB4\xCE\xB1",
     ],
     ["\xD0\xA0\xD1\x83\xD1\x81\xD1\x81\xD0\xBA\xD0\xB8\xD0\xB9",
      "\xD0\xA0\xD1\x83\xD1\x81\xD1\x81\xD0\xBA\xD0\xB8\xD0\xB8",
     ],
    ],
   ],

   ['UTF-16BE',
    [
     ["",
      "",
     ],
     ["\x00n\x00a\x00\xEF\x00v\x00e",
      "\x00n\x00a\x00i\x00v\x00e",
     ],
     ["\x00d\x00\xE9\x00j\x00\xE0\x00 \x00v\x00u",
      "\x00d\x00e\x00j\x00a\x00 \x00v\x00u",
     ],
     ["\x00E\x00s\x00p\x00a\x00\xF1\x00a",
      "\x00E\x00s\x00p\x00a\x00n\x00a",
     ],
     ["\x00F\x00r\x00a\x00n\x00\xE7\x00a\x00i\x00s",
      "\x00F\x00r\x00a\x00n\x00c\x00a\x00i\x00s",
     ],
     ["\x00C\x00i\x00t\x00r\x00o\x00\xEB\x00n",
      "\x00C\x00i\x00t\x00r\x00o\x00e\x00n",
     ],
     ["\x00N\x00j\x00\xE5\x00l\x00 \x00S\x00\xE6\x00b\x00\xF8",
      "\x00N\x00j\x00a\x00l\x00 \x00S\x00a\x00e\x00b\x00o",
     ],
     ["\x03\x95\x03\xBB\x03\xBB\x03\xAC\x03\xB4\x03\xB1",
      "\x03\x95\x03\xBB\x03\xBB\x03\xB1\x03\xB4\x03\xB1",
     ],
     ["\x04 \x04C\x04A\x04A\x04:\x048\x049",
      "\x04 \x04C\x04A\x04A\x04:\x048\x048",
     ],
    ],
   ],

  ];

print "1..30\n";

my $testno = 0;
for (my $i = 0 ; $i <= $#$data ; ++ $i) {

    my $encoding_name = $data->[$i][0];
    my $encoding_data = $data->[$i][1];

    for (my $j = 0 ; $j <= $#$encoding_data ; ++ $j) {
        ++ $testno;

        my $in           = $encoding_data->[$j][0];
        my $out_expected = $encoding_data->[$j][1];

        my $out_actual   = unac_string($encoding_name, $in);

        unless (defined $out_actual) {
            print "not ok ", $testno, "\n";
            print "  input ......: ", nice_string($in), "\n";
            print "  got ........: <UNDEF>\n";
            print "  expected ...: ", nice_string($out_expected), "\n";
            print "  encoding ...: $encoding_name\n";
            print "  error ......: the output is undefined\n";
            next;
        }

        unless ($out_actual eq $out_expected) {
            print "not ok ", $testno, "\n";
            print "  input ......: ", nice_string($in), "\n";
            print "  got ........: ", nice_string($out_actual), "\n";
            print "  expected ...: ", nice_string($out_expected), "\n";
            print "  encoding ...: $encoding_name\n";
            print "  error ......: the actual output is not identical to",
              " the expected output\n";
            next;
        }

        print "ok ", $testno, "\n";

    }
}

# Emacs Local Variables:
# Emacs coding: iso-8859-1
# Emacs mode: perl
# Emacs End:
