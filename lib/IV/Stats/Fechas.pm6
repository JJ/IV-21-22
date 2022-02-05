use IO::Glob;
use Git::File::History;
use IV::Stats;

enum Estados is export <CUMPLIDO ENVIADO INCOMPLETO NINGUNO>;

sub estado-objetivos( @student-list, $contenido) is export {
    my @contenido = $contenido.split("\n").grep(/"|"/)[2..*];
    my %estados;
    for @student-list.kv -> $index, $usuario {
        my $marca = @contenido[$index] // "";
        if  $marca  ~~  /"✓"/ {
            %estados{$usuario} = CUMPLIDO;
        } elsif  $marca ~~ /"✗"/  {
            %estados{$usuario} = INCOMPLETO;
        } elsif  $marca ~~ /"github.com"/  {
            %estados{$usuario} = ENVIADO
        }
    }
    return %estados;
}

unit class IV::Stats::Fechas;

has @!fechas-entregas;

submethod BUILD( :@!fechas-entregas) {}

method new() {
    my @student-list = lista-estudiantes();
    my $file-history = Git::File::History.new(:files("proyectos/objetivo-*.md"));
    my @fechas-entregas;
    for glob( "proyectos/objetivo-*.md" ).sort: { $^a cmp $^b} -> $f {
        my ($objetivo) := $f ~~ /(\d+)/;
        @fechas-entregas[$objetivo]={};
        for $file-history.history-of( ~$f )<> -> %file-version {
            my $this-version = %file-version<state>;
            my $fecha = %file-version<date>;
            my %estado-objetivos = estado-objetivos( @student-list,
                    $this-version);
            for %estado-objetivos.kv -> $estudiante, $estado {
                my $estado-actual =
                        @fechas-entregas[$objetivo]{$estudiante}<entrega>;
                given $estado {
                    when ENVIADO {
                        if !$estado-actual {
                            @fechas-entregas[$objetivo]{$estudiante}<entrega>
                                    = $fecha;
                        }
                    }
                    when CUMPLIDO {
                        if $estado-actual
                                && !@fechas-entregas[$objetivo]{$estudiante}<corregido> {
                            @fechas-entregas[$objetivo]{$estudiante}<corregido>
                                    = $fecha;
                        }
                    }
                    when INCOMPLETO {
                        if $estado-actual {
                            @fechas-entregas[$objetivo]{$estudiante}<corregido>
                                    = $fecha;
                            @fechas-entregas[$objetivo]{$estudiante}<incompleto> = True;
                        }
                    }
                }
            }
        }
    }
    self.bless( :@fechas-entregas);
}

method entregas-de( Int $objetivo, Str $estudiante ){
    return @!fechas-entregas[$objetivo]{$estudiante};
}

method to-CSV() {
    my $csv = "Objetivo;Estudiante;Entrega;Correccion;Incompleto";
    for @!fechas-entregas.kv -> $o, %fechas {
        next unless %fechas;
        for %fechas.kv -> $estudiante, %datos {
            my $fila = "\n$o; $estudiante;";
            for <entrega corregido> -> $e {
                my $dato = %datos{$e} // "";
                $fila ~= "$dato;";
            }
            if %datos<incompleto> {
                $fila ~= "Incompleto";
            } else {
                $fila ~= "Completo";
            }
            $csv ~= $fila;
        }

    }
    return $csv;
}
