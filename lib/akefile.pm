##
# name:      akefile
# abstract:  Generate a Makefile.PL in your favorite style
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2011

use 5.006;
use File::Share 0.01 ();
use IO::All 0.43 ();
use Mo 0.22 ();
use Template::Toolkit::Simple 0.13 ();

package akefile;
use Mo;
our $VERSION = '0.03';

use IO::All;

has type => ();
has args => (default => sub{[]});
has data => (builder => 'get_data');
has target_file => (default => sub {'Makefile.PL'});
has run_command => (default => sub {"$^X Makefile.PL"});

use XXX;

sub import {
    my $pkg = shift;
    my $type = shift or return;
    my $self = $pkg->new(
        type => $type,
    );
    $self->args([@_]);
    
    my ($main, $e) = caller(0);
    return unless $main eq 'main' and $e eq '-e' or $e eq '-';

    my $path = File::Share::dist_file(__PACKAGE__, $type)
        or die "'$type' is not a currently know akefile type";
    my $template = io($path)->all;
    
    Template::Toolkit::Simple->new()
        ->path([File::Share::dist_dir(__PACKAGE__)])
        ->data($self->data)
        ->output($self->target_file)
        ->render(\$template);

    exec $self->run_command;
}

sub get_data {
    my $self = shift;
    my $data = {
        map {
            split '=', $_, 2;
        } grep {
            $_ =~ /=/;
        } @{$self->args}
    };
    return $data;
}

1;

=head1 SYNOPSIS

From command line:

    perl -Makefile=PL   # Create a Makefile.PL and run it
    make test           # test
    make install        # install
    make purge          # Clean up and delete the Makefile.PL

Other invocations:

    perl Makefile=MI    # Module Install
    perl Makefile=MP    # Module Package
    perl Makefile=MB    # Module Build
    perl Makefile=DZ    # DistZilla
    perl Makefile=XY    # From akefile::XY plugin

=head1 DESCRIPTION

This module will attempt to generate a Makefile.PL for you, so that you can
stop worrying about that stuff.

=head1 STATUS

This module is brand new. Don't use it yet.

