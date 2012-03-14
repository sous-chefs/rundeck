#!/usr/bin/perl
#############################################################################
# $Id: snmp_rndc_stats.pl 6 2010-03-23 18:34:06Z wolfe21 $
# $URL: svn://osl.marshall.edu/zenoss/snmp_rndc_stats/snmp_rndc_stats.pl $
# $Date: 2010-03-23 14:34:06 -0400 (Tue, 23 Mar 2010) $
# $Author: wolfe21 $
# $Rev: 6 $
# Program  : snmp_rndc_stats.pl
# Purpose  : This script will allow you to display bind9 stats via SNMP.
#          : A Network Monitoring can then use those stats to build rrd
#          : graphs representing DNS stats.
# License  : Artistic Perl 2.0
# (C) 2010 : Gerald L. Hevener, M.S., and Eric G. Wolfe

#enable strict and warnings
use warnings;
use strict;

#import required modules
use Carp;
use version; our $VERSION = qv(1.0.5);

# Declare init_stats_file() parameters
my $rndc_cmd   = '/usr/sbin/rndc stats';
my $stats_file = '/var/named/data/named_stats.txt';

#############################################################################
# Usage      : init_stats_file( $rndc_cmd, $stats_file )
# Purpose    : Zeroes out DNS rndc stats file, if older than 10 minutes.
# Returns    : implicit
# Parameters : $rndc_cmd, $stats_file
# Throws     : no exceptions
# Comments   : Set appropriate $rndc_cmd, and $stats_file vars above.
# See Also   : n/a
sub init_stats_file {

    my ( $rndc_cmd, $stats_file ) = @_;

    # Only re-write the file if it's almost five minutes old.
    my $almost_five_minutes = 4.9 / 60 / 24;

    # declare variables local to sub
    my $cp_cmd       = "/bin/cp -f $stats_file $stats_file.backup";
    my $zero_out_cmd = "/bin/cp -f /dev/null $stats_file";

    # Get File modification time.
    my $file_age = -M $stats_file;

    if ( $file_age >= $almost_five_minutes ) {

        #make backup of $stats_file
        system $cp_cmd;

        #zero out contents of $stats_file. Otherwise stats
        #will get appended to $stats_file.
        system $zero_out_cmd;

        #execute $rndc_cmd to update $stats_file
        system $rndc_cmd;
    }

    #end build_rndc_stats
    return;
}

# Initialize stats file
init_stats_file( $rndc_cmd, $stats_file );

# Specify the usage specification for the program
my $specification = <<'USAGE_SPEC';
  --success	Print rndc success stats
		  { rndc_stats ("success") }
  --referral	Print rndc referral stats
		  { rndc_stats ("referral") }
  --nxrrset	Print rndc nxrrset stats
		  { rndc_stats ("nxrrset") }
  --nxdomain	Print rndc nxdomain stats
		  { rndc_stats ("nxdomain") }
  --recursion	Print rndc recursion stats
		  { rndc_stats ("recursion") }
  --failure	Print rndc failure stats
		  { rndc_stats ("failure") }
  --all		Print all rndc stats
		  { all_rndc_stats() }
  <unknown>	
		  
		  { $self->usage(0) }
USAGE_SPEC

# Automatically generates help, usage, version informations
# See specification above for details.
use Getopt::Declare;
my $args = Getopt::Declare->new($specification);

#############################################################################
# Usage      : all_rndc_file( $rndc_cmd, $stats_file )
# Purpose    : prints out all the rndc stats for troubleshooting 
# Returns    : implicit
# Parameters : n/a 
# Throws     : no exceptions
# Comments   : the only function intended to be used interactively 
# See Also   : n/a
sub all_rndc_stats {

	# Define stat definititions
    my @stat_functions
        = qw( success referral nxrrset nxdomain recursion failure );

	# Print them each on the CLI
    foreach my $stat_function (@stat_functions) {
        rndc_stats($stat_function);
		print "\n";
    }

    #end all_rndc_stats
    return;
}

#############################################################################
# Usage      : rndc_stats( $stat_function )
# Purpose    : prints out the rndc stat defined by $stat_function
# Returns    : implicit
# Parameters : n/a
# Throws     : no exceptions
# Comments   : newlines are printed, because this output is meant for snmpd
# See Also   : n/a
sub rndc_stats {

    # Pop stat_function off of sub args
    my ($stat_function) = @_;

    #open fh for $stats_file
    open my $STAT_FH, '<', $stats_file
        or confess "Can't open file: $!";

    # Slurp stat_file and close
    my @stat_file = <$STAT_FH>;
    close $STAT_FH
        or confess "Can't close file: $!";

    #read file and only get success stat
    foreach my $stat_value (@stat_file) {

        #chomp new lines
        chomp $stat_value;

        $stat_function =~ s/failure/servfail/g;

        if ( $stat_value =~ /^\s+(\d+)\s+queries\s+(caused|resulted\s+in)\s+$stat_function(ful)?(\s+answer)?$/ixms ) {

            $stat_value = $1;

            #print success stat
            print "$stat_value";
        }

        #close while loop
    }

    #close rndc_stats()
    return;
}

__END__

=pod

=head1 NAME

snmp_rndc_stats - extend L<rndc(8)> stats for L<snmpd(8)> daemon

=head1 VERSION

This documentation refers to snmp_rndc_stats version 1.0.4

=head1 USAGE 

You may test the output of the command, by running it manually.
However, the output is meant to be passed to L<snmpd(8)> Therefore, the output may appear to you as a useless string of numbers without a
newline at the end.

=head1 REQUIRED ARGUMENTS

All arguments are optional. See options section for more information.

=head1 OPTIONS

Optional arguments follow.

=over

=item --success Prints rndc success stats

=item --referral Prints rndc referral stats

=item --nxrrset Prints rndc nxrrset stats

=item --nxdomain Prints rndc nxdomain stats

=item --recursion Prints rndc recursion stats

=item --failure Prints rndc failure stats

=item --all Prints all rndc stats

=back

=head1 DIAGNOSTICS

The only errors generated are file open errors.  Carp confess is used to
generate a backtrace of any resulting errors.

=head1 EXIT STATUS

Don't expect any special exit status.  If you have a case where you need to
test the exit status, we'll graciously accept a patch.

=head1 CONFIGURATION AND ENVIRONMENT

Copy the program to /usr/local/bin. Add the following to your
/etc/snmp/snmpd.conf. See the following configuration section for example
extend configuration.

=head1 CONFIGURATION

=over

=item extend bindSuccess /usr/local/bin/snmp_rndc_stats.pl --success

=item extend bindReferral /usr/local/bin/snmp_rndc_stats.pl --referral

=item extend bindNxrrset /usr/local/bin/snmp_rndc_stats.pl --nxrrset

=item extend bindNxdomain /usr/local/bin/snmp_rndc_stats.pl --nxdomain

=item extend bindRecursion /usr/local/bin/snmp_rndc_stats.pl --recursion

=item extend bindFailure /usr/local/bin/snmp_rndc_stats.pl --failure

=back

=head1 DESCRIPTION

This program will read DNS statistics written by L<rndc(8)> stats.
This program is meant to be used with extend in L<snmpd.conf(5)> configuration file.
When you use this program in co-operation with L<snmpd(8)>. You may then graph these
statistics in any Network Monitoring System which supports SNMP monitoring.

=head1 DEPENDENCIES

You will need the following Perl modules from CPAN, if not installed.

=over

=item L<Carp>

=item L<version>

=item L<Getopt::Declare>

=back

=head1 BUGS AND LIMITATIONS

There are no known bugs in this application.
Please report problems to one of the authors.

Patches are welcome.

=head1 INCOMPATIBILITIES

There are no known incompatibilities in this application. Please report any
critical incompatibilities to the authors.

=head1 AUTHOR

=over

=item Gerald Hevener, M.S. E<lt>hevenerg (at) marshall (dot) eduE<gt>

=item Eric G. Wolfe E<lt>wolfe21 (at) marshall (dot) eduE<gt>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010

=over

=item Gerald Hevener, M.S. E<lt>hevenerg (at) marshall (dot) eduE<gt>,

=item Eric G. Wolfe E<lt>wolfe21 (at) marshall (dot) eduE<gt>

=back

All rights reserved.

This application is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

