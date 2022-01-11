#!/usr/bin/env perl6

use IO::Glob;
use IV::Stats;

say IV::Stats.new.notas.map( *.trans( "." => "," )).join("\n");

