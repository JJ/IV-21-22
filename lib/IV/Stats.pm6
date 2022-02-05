use IO::Glob;
use Git::File::History;


sub lista-estudiantes( Str $file = "proyectos/usuarios.md" ) is export {
    $file.IO.slurp.lines.grep( /"<!--"/ )
            .map( *.split( "--" )[1].split(" ")[3]);
}

unit class IV::Stats;

has @!student-list;
has %!students;
has @!objetivos;
has @!entregas;

my @cumplimiento=[.05,.075, .15, .075, .15, 0.05, 0.05, 0.1, 0.1, 0.1, 0.1 ];

method new( Str $file = "proyectos/usuarios.md") {
    my @student-list = lista-estudiantes( $file );
    my %students;
    my @objetivos;
    my @entregas;
    @student-list.map: { %students{$_} = { :objetivos(set()), :entrega(0) } };

    for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
        my ($objetivo) := $f ~~ /(\d+)/;
        my @contenido = $f.IO.lines.grep(/"|"/);
        @objetivos[$objetivo] = set();
        @entregas[$objetivo] = set();
        for @student-list.kv -> $index, $usuario {
            if ( @contenido[$index + 2] ~~ /"✓"/ ) {
                %students{$usuario}<objetivos> ∪= +$objetivo;
                @objetivos[$objetivo] ∪= $usuario;
            }
            if ( @contenido[$index + 2] ~~ /"github.com"/ ) {
                %students{$usuario}<entrega> = +$objetivo ;
                @entregas[$objetivo] ∪= $usuario;
            }
        }
    }
    self.bless( :@student-list, :%students, :@objetivos, :@entregas );
}

submethod BUILD( :@!student-list, :%!students, :@!objetivos, :@!entregas) {}

method objetivos-de( Str $user  ) {
    return %!students{$user}<objetivos>;
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

method notas( --> Seq ) {
    return gather for @!student-list -> $u {
        my $nota = 0;
        for  %!students{$u}<objetivos>.list.keys -> $n {
            $nota += @cumplimiento[$n]
        }
        take $nota*7;
    }
}

