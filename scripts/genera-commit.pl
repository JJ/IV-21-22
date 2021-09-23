#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use Git;

my $repo = Git->repository;

my @diffs = $repo->command('diff', 'HEAD~', 'HEAD');

my @adds = grep( /\+.+✓/, @diffs );

my $aceptados = "";
for my $a (@adds) {
  my ($usuario) = ($a =~ /github\.com\/(\w+)/);
  $aceptados .= " \@$usuario ";
}

say $aceptados;
