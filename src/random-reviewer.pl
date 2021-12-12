#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use File::Slurper 'read_text';
use GitHub::Actions;
use List::Util qw(min);

use constant MAXREVIEWERS => 3;

my $objetivos_json = read_text( "data/objetivos.json" ) || die "No encuentro el fichero de objetivos";

my @objetivos = @{from_json( $objetivos_json )};

my $este_objetivo = $ENV{'objetivo'};

my @reviewers;
my @these_students = @{$objetivos[$este_objetivo]};
my $num_reviewers = min(MAXREVIEWERS, scalar @these_students);

for ( my $i = 0; $i < $num_reviewers; $i ++ ) {
  my $this_reviewer = splice( @these_students, int(rand( $#these_students ) ), 1 );
  push( @reviewers, "\@".$this_reviewer );
}

warning( "⛹ Revisores → ". join(" ", @reviewers) );
