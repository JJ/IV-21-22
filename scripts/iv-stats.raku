#!/usr/bin/env perl6


use IO::Glob;

for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
    my @contenido = $f.IO.lines;
    my $todos = @contenido.grep( /"|"/).elems -2;
    my @entregados = @contenido.grep( /github\.com/ );
    my @aceptados = @entregados.grep( /"✓"/ );
    my $objetivo = + ($f ~~ /(\d+)/);
    say sprintf( "%2d ⇒ ", $objetivo ),
            ("🚧" xx @entregados.elems - @aceptados.elems,
            "✅" xx @aceptados.elems,
            "❌" xx $todos - @entregados.elems).Slip.join("\n     ");

}
