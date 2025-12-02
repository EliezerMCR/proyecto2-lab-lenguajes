:- dynamic mostro/4.

% mostro(nombre, nivel, atributo, poder).
mostro(mostroUno, 5, luz, 2100).
mostro(mostroDos, 7, luz, 2400).
mostro(mostroTres, 7, viento, 2500).

% Predicado auxiliar: verifica si un atributo es válido
atributoValido(Atributo) :-
    member(Atributo, [agua, fuego, viento, tierra, luz, oscuridad, divino]).

% Predicado auxiliar: verifica si dos mostros comparten exactamente una característica
% comparteExactamenteUna(Mostro1, Mostro2)
comparteExactamenteUna(Nombre1, Nombre2) :-
    mostro(Nombre1, Nivel1, Atributo1, Poder1),
    mostro(Nombre2, Nivel2, Atributo2, Poder2),
    Nombre1 \= Nombre2,  % Asegurarse de que no sean el mismo mostro por instancia
    % Contar cuántas características comparten
    (Nivel1 = Nivel2 -> ComparteNivel = 1 ; ComparteNivel = 0),
    (Atributo1 = Atributo2 -> ComparteAtributo = 1 ; ComparteAtributo = 0),
    (Poder1 = Poder2 -> CompartePoder = 1 ; CompartePoder = 0),
    Total is ComparteNivel + ComparteAtributo + CompartePoder,
    Total =:= 1.  % Exactamente una característica en común

% ternaMundoChiquito(X, Y, Z)
% X: mostro revelado de la mano
% Y: mostro revelado del mazo (comparte exactamente 1 característica con X)
% Z: mostro agregado del mazo a la mano (comparte exactamente 1 característica con Y)
ternaMundoChiquito(X, Y, Z) :-
    mostro(X, _, _, _),
    mostro(Y, _, _, _),
    mostro(Z, _, _, _),
    comparteExactamenteUna(X, Y),  % X y Y comparten exactamente 1 característica
    comparteExactamenteUna(Y, Z).  % Y y Z comparten exactamente 1 característica

% mundoChiquito
% Imprime todas las ternas válidas, una por línea
mundoChiquito :-
    forall(
        ternaMundoChiquito(X, Y, Z),
        (write(X), write(' '), write(Y), write(' '), write(Z), nl)
    ).
% Predicado para listar todos los mostros
listarMostros :-
    write('Lista de mostros en la base de conocimiento:'), nl,
    forall(mostro(Nombre, Nivel, Atributo, Poder),
           (format('Nombre: ~w, Nivel: ~w, Atributo: ~w, Poder: ~w~n', [Nombre, Nivel, Atributo, Poder]))).

           
% agregarMostro
% Lee información de un mostro por consola y lo agrega a la base de conocimiento
agregarMostro :-
    write('Ingrese los datos del mostro en el siguiente formato:'), nl,
    write('mostro(nombre, nivel, atributo, poder).'), nl,
    write('Ejemplo: mostro(dragonBlanco, 8, luz, 3000).'), nl,
    write('> '),
    catch(
        read(Mostro),
        _Error,
        (write('Error al ingresar el mostro. Asegúrese de seguir el formato correcto.'), nl,
         write('Ejemplo válido: mostro(dragonBlanco, 8, luz, 3000)'), nl,
         fail)
    ),
    % Verificar que tenga el formato correcto
    (   Mostro = mostro(Nombre, Nivel, Atributo, Poder)
    ->  (   atom(Nombre),  Nombre \= '', % Verificar que el nombre no esté vacío
            integer(Nivel),
            Nivel >= 1,
            Nivel =< 12,
            atributoValido(Atributo),
            integer(Poder),
            Poder > 0,
            Poder mod 50 =:= 0
        -> (   mostro(Nombre, _, _, _)  % Verificar si el mostro ya existe
            ->  write('Error: Ya existe un mostro con ese nombre.'), nl
            ;   assertz(mostro(Nombre, Nivel, Atributo, Poder)),
                write('Mostro agregado exitosamente: '),
                write('¡Mostro agregado exitosamente!'), nl,
                write('Nombre: '), write(Nombre), nl,
                write('Nivel: '), write(Nivel), nl,
                write('Atributo: '), write(Atributo), nl,
                write('Poder: '), write(Poder), nl
            )
        ;   write('Error: Los datos no cumplen con las restricciones.'), nl,
            (   \+ atom(Nombre) -> write('- Nombre debe ser un átomo'), nl ; true),
            (   \+ integer(Nivel) -> write('- Nivel debe ser un entero entre 1 y 12'), nl ; true),
            (   \+ (Nivel >= 1, Nivel =< 12) -> write('- Nivel debe estar entre 1 y 12'), nl ; true),
            (   \+ atributoValido(Atributo) -> write('- Atributo debe ser uno de: agua, fuego, viento, tierra, luz, oscuridad, divino'), nl ; true),
            (   \+ (integer(Poder), Poder > 0, Poder mod 50 =:= 0) -> write('- Poder debe ser un entero positivo múltiplo de 50'), nl ; true)
        )
    ;   write('Error: Formato incorrecto. Use: mostro(nombre, nivel, atributo, poder).'), nl
    ).
