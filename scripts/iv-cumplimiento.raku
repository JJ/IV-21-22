#!/usr/bin/env perl6


use IO::Glob;

my @usuarios = "proyectos/usuarios.md".IO.slurp.lines.grep( /"<!--"/ )
        .map( *.split( "--" )[1].split(" ")[3]);
my %latest;
my @cumplimiento=[.05,.075, .15, .075, .15, 0.05, 0.05, 0.075, 0.05, 0.075, 0.05, 0.075, 0.05, 0.025 ];
say [+] @cumplimiento;
for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
    my @contenido = $f.IO.lines.grep( /"|"/);
    for @usuarios.kv -> $index, $usuario {
        %latest{$usuario}++ if @contenido[$index+2] ~~ /"✓"/;
    }
}

for %latest.sort( { $^b.value <=> $^a.value } ) -> $p {
    my ($u,$v) = $p.kv;
    my $porcentaje = [+]  @cumplimiento[ ^$v];
    say $u, " → ", $porcentaje, ": ", $porcentaje * 7;
}
