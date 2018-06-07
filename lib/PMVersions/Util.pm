package PMVersions::Util;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Config::IOD::Reader;
use File::HomeDir;

use Exporter qw(import);
our @EXPORT_OK = qw(read_pmversions version_from_pmversions);

sub read_pmversions {
    my ($path) = @_;

    $path //= $ENV{PMVERSIONS_PATH};
    $path //= File::HomeDir->my_home . "/pmversions.ini";
    my $hoh;
    if (-e $path) {
        $hoh = Config::IOD::Reader->new->read_file($path);
    } else {
        die "pmversions file '$path' does not exist";
    }

    $hoh->{GLOBAL} // {};
}

my $pmversions;
sub version_from_pmversions {
    my ($mod, $path) = @_;

    $pmversions //= read_pmversions($path);
    $pmversions->{$mod};
}

1;
# ABSTRACT: Utilities related to pmversions.ini

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<~/pmversions.ini>:

 Log::ger=0.023
 File::Write::Rotate=0.28

In your code:

 use PMVersions::Util qw(version_from_pmversions);

 my $v1 = version_from_pmversions("Log::ger");  # => 0.023
 my $v2 = version_from_pmversions("Data::Sah"); # => undef


=head1 DESCRIPTION

F<pmversions.ini> is a file that list (minimum) version of modules. This module
provides routines related to this file.


=head1 FUNCTIONS

=head2 read_pmversions

Usage:

 read_pmversions([ $path ]) => hash

Read F<pmversions.ini> and return a hash of module names and versions. If
C<$path> is not specified, will look at C<PMVERSIONS_PATH> environment variable,
or defaults to F<~/pmversions.ini>. Will die if file cannot be read or parsed.

=head2 version_from_pmversions

Usage:

 version_from_pmversions($mod [ , $path ]) => str

Check version from pmversions file. C<$path> will be passed to
L</"read_pmversions"> only the first time; after that, the contents of the file
is cached in a hash variable so the pmversions file is only read and parsed
once.


=head1 ENVIRONMENT

=head2 PMVERSIONS_PATH

String. Set location of F<pmversions.ini> instead of the default
C<~/pmversions.ini>. Example: C</etc/minver.conf>.


=head1 SEE ALSO
