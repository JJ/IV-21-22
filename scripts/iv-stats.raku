#!/usr/bin/env perl6

use IV::Stats;

my $stats = IV::Stats.new;
my $todos = $stats.estudiantes.elems;

for $stats.objetivos -> $o {
    my $aceptados = $stats.cumple-objetivo($o).elems;
    my $entregados = $stats.hecha-entrega($o).elems;
    say sprintf( "%2d 🧮: %2d%%🚧 %2d%%✅ %2d%%❌ ⇒ \n     ",
            $o,
            ($entregados - $aceptados) *100/ $todos,
            $aceptados*100/ $todos,
            ($todos - $entregados)*100/$todos  ),
            ("🚧" xx ($entregados - $aceptados),
            "✅" xx $aceptados,
            "❌" xx $todos - $entregados).Slip.join("\n     ");

}
