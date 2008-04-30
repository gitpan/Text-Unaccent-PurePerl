#!perl
#
# Author:      Peter J. Acklam
# Time-stamp:  2008-04-30 08:27:22 +02:00
# E-mail:      pjacklam@online.no
# URL:         http://home.online.no/~pjacklam

use 5.006;
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile
  (
   (MM->can('signature_target') ? (SIGN => 1) : ()),
   NAME                => 'Text::Unaccent::PurePerl',
   AUTHOR              => 'Peter John Acklam <pjacklam@cpan.org>',
   VERSION_FROM        => 'lib/Text/Unaccent/PurePerl.pm',
   ABSTRACT_FROM       => 'lib/Text/Unaccent/PurePerl.pm',
   PL_FILES            => {},
   PREREQ_PM           => { 'Test::More' => 0, },
   dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
   clean               => { FILES => 'Text-Unaccent-PurePerl-*' },
  );
