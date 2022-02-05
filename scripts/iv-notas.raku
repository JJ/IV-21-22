#!/usr/bin/env perl6

use IV::Stats;

say IV::Stats.new.notas.map( *.trans( "." => "," )).join("\n");

