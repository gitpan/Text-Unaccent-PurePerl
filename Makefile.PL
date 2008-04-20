use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Text::Unaccent::PurePerl',
    AUTHOR              => 'Peter J. Acklam <pjacklam@cpan.org>',
    VERSION_FROM        => 'lib/Text/Unaccent/PurePerl.pm',
    ABSTRACT_FROM       => 'lib/Text/Unaccent/PurePerl.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-Unaccent-PurePerl-*' },
);
