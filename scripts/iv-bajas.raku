#!/usr/bin/env perl6

use IV::Stats;

my $stats = IV::Stats.new;

for $stats.objetivos -> $o {
    if ( $stats.bajas-totales($o) != set( Any ) ) {
        say "⬇️ 📉 $o ", $stats.bajas-totales($o).keys.join(" 🧍 ");
        say "⬇️ 🎯 $o ", $stats.bajas-objetivos($o).keys.join(" 🧍 ");
    }
}
