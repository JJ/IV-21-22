use IO::Glob;

unit class IV::Stats;

has %!students;
has @!objetivos;
has @!entregas;

method new( Str $file = "proyectos/usuarios.md") {
    my @students = $file.IO.slurp.lines.grep( /"<!--"/ )
        .map( *.split( "--" )[1].split(" ")[3]);
    my %students;
    my @objetivos;
    my @entregas;
    @students.map: { %students{$_} = { :objetivo(0), :entrega(0) } };
    for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
        my ($objetivo) := $f ~~ /(\d+)/;
        my @contenido = $f.IO.lines.grep(/"|"/);
        @objetivos[$objetivo] = set();
        @entregas[$objetivo] = set();
        for @students.kv -> $index, $usuario {
            if ( @contenido[$index + 2] ~~ /"✓"/ ) {
                %students{$usuario}<objetivo> = +$objetivo;
                @objetivos[$objetivo] ∪= $usuario;
            }
            if ( @contenido[$index + 2] ~~ /"github.com"/ ) {
                %students{$usuario}<entrega> = +$objetivo ;
                @entregas[$objetivo] ∪= $usuario;
            }
        }
    }
    self.bless( :%students, :@objetivos, :@entregas );
}

submethod BUILD( :%!students, :@!objetivos, :@!entregas) {}

method objetivos-de( Str $user  ) {
    return %!students{$user}<objetivo>;
}

method entregas-de( Str $user ) {
    return %!students{$user}<entrega>;
}

method cumple-objetivo( UInt $objetivo ) {
    return @!objetivos[$objetivo];
}

method hecha-entrega( UInt $entrega ) {
    return @!entregas[$entrega];
}

method bajas-objetivos( UInt $objetivo) {
    return @!objetivos[$objetivo] ⊖  @!objetivos[$objetivo + 1];
}

method bajas-totales( UInt $objetivo) {
    return @!objetivos[$objetivo] ⊖  @!entregas[$objetivo + 1];
}

method objetivos() {
    return @!entregas.keys;
}

method estudiantes() {
    return %!students.keys;
}

method objetivos-cumplidos() {
    return @!objetivos.map( *.keys.sort( { $^a.lc cmp $^b.lc }) );
}
