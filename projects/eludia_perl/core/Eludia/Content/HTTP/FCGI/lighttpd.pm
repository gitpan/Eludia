#!/usr/bin/perl

use FCGI;
use IO;
use Time::HiRes 'time';
use Eludia::Content::HTTP::API;

our $fake_stderr = new IO::File;

print STDERR "Eludia for lighttpd is starting\n";

my $configs = {};

my $request = FCGI::Request (\*STDIN, \*STDOUT, $fake_stderr, \%ENV, 0, 0);

my $handling_request = 0;
my $exit_requested = 0;

$SIG{PIPE} = sub {warn "PIPE!\n"};

my $requests = 200;

while ($requests --) {

	$handling_request = $request -> Accept;
	
	last if $handling_request < 0;
	
	my $time = time;

	my $app = $ENV {DOCUMENT_ROOT};
	
	$app =~ s{/docroot/?$}{};
	
	open STDERR, ">>$app/logs/error.log" or die "Can't write to $app/logs/error.log: $!\n";
	
	check_configuration_and_handle_request_for_application ($app);
	
	$handling_request = 0;

	last if $exit_requested;

}

$request -> Finish;

exit (0);

1;
