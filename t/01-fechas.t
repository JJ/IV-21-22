#!/usr/bin/env raku

use Test;
use IV::Stats;
use IV::Stats::Fechas;

my $fechas = IV::Stats::Fechas.new;

ok( $fechas, "Can create object");
isa-ok( $fechas, IV::Stats::Fechas, "Clase correcta" );

my %una-fecha =$fechas.entregas-de( 9, "amerigal" );

for <entrega corregido> -> $k {
    ok( %una-fecha{$k}, "$k correcto" );
}

my @csv = $fechas.to-CSV.split("\n");
cmp-ok( @csv.elems, ">", 260, "CSV generado guay");
like( @csv.tail(2), /amerigal/, "Last row OK");

done-testing;
