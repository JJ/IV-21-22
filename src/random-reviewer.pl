#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use File::Slurper 'read_text';
use GitHub::Actions;
use LWP::UserAgent;

use constant MAXREVIEWERS => 3;

my $objetivos_json = read_text( "data/objetivos.json" ) || die "No encuentro el fichero de objetivos";

my @objetivos = @{from_json( $objetivos_json )};

my $este_objetivo = $ENV{'objetivo'};
my $user          = $ENV{'user'};
my $repo          = $ENV{'repo'};
my $pull_number   = $ENV{'pull_number'};
my $auth_token    = $ENV{'GITHUB_TOKEN'};

my @reviewers;
my @these_students = @{$objetivos[$este_objetivo]};
my $num_reviewers = scalar(@these_students) < MAXREVIEWERS ? scalar(@these_students) : MAXREVIEWERS;

for ( my $i = 0; $i < $num_reviewers; $i ++ ) {
  my $this_reviewer = splice( @these_students, int(rand( $#these_students ) ), 1 );
  push( @reviewers, "\@".$this_reviewer );
}

my $data = "⛹ Revisores → ". join(" ", @reviewers);
my $post_data = sprintf('{"body":"%s"}', $data);
my $url = sprintf('https://api.github.com/repos/%s/%s/issues/%s/comments', $user, $repo, $pull_number);

warning($data);

my $ua = LWP::UserAgent->new();
my $request = new HTTP::Request('POST' => $url,
                                [
                                 'Authorization' => "token $auth_token",
                                 'Accept' =>  'application/vnd.github.v3.raw'
                                ]);
$request->content($post_data);
my $response = $ua->request($request)->as_string() || die "No puedo poner comentario: $@";

