#!/usr/bin/env perl6


use IO::Glob;

my @usuarios = "proyectos/usuarios.md".IO.slurp.lines.grep( /"<!--"/ )
        .map( *.split( "--" )[1].split(" ")[3]);
my %latest;
my @cumplimiento=[.05,.075, .15, .075, .15, 0.05, 0.05, 0.1, 0.1, 0.1, 0.1 ];
for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
    my @contenido = $f.IO.lines.grep( /"|"/);
    for @usuarios.kv -> $index, $usuario {
        %latest{$usuario}++ if @contenido[$index+2] ~~ /"✓"/;
    }
}

for @usuarios -> $u {
    if  %latest{$u}.defined {
        say (7 * ( [+]  @cumplimiento[ ^%latest{$u} ] )).trans("." => ",");
    } else {
        say 0;
    }
}
