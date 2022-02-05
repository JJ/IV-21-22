#!/usr/bin/env perl6

use IV::Stats;
use JSON::Fast;

say to-json IV::Stats.new.objetivos-cumplidos;
