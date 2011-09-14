##
# name:      ake
# abstract:  -make things happen for perl
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2011

package ake;
use Mo;

sub assert_makefile {
    if (not -f 'Makefile.PL') {
        system("$^X -Makefile=PL");
    }
    elsif (not -f 'Makefile') {
        system("$^X Makefile.PL");
    }
}

BEGIN {
    {
        no warnings;
        return unless $^I eq 'nstall';
    }
    assert_makefile();
    exec("make install");
}

sub main::st {
    assert_makefile();
    exec("make test");
}

1;

=head1 SYNOPSIS

From command line:

    perl -make -test
    perl -make -install

=head1 DESCRIPTION

Save a step when dealing with Perl modules.

=head1 STATUS

This module is brand new. Don't use it yet.

