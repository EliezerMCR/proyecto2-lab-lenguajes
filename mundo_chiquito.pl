:- dynamic mostro/4.

% mostro(nombre, nivel, atributo, poder).
mostro(mostroUno, 5, luz, 2100).
mostro(mostroDos, 7, luz, 2400).
mostro(mostroTres, 7, viento, 2500).

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

% agregarMostro
% Lee información de un mostro por consola y lo agrega a la base de conocimiento
agregarMostro :-
    write('Ingrese los datos del mostro en el siguiente formato:'), nl,
    write('mostro(nombre, nivel, atributo, poder).'), nl,
    write('Ejemplo: mostro(dragonBlanco, 8, luz, 3000).'), nl,
    write('> '),
    read(Mostro),
    % Verificar que tenga el formato correcto
    (   Mostro = mostro(Nombre, Nivel, Atributo, Poder)
    ->  (   atom(Nombre),
            integer(Nivel),
            Nivel >= 1,
            Nivel =< 12,
            atom(Atributo),
            integer(Poder),
            Poder mod 50 =:= 0
        ->  assertz(mostro(Nombre, Nivel, Atributo, Poder)),
            write('Mostro agregado exitosamente: '),
            write(Nombre), nl
        ;   write('Error: Los datos no cumplen con las restricciones.'), nl,
            write('- Nombre debe ser un átomo'), nl,
            write('- Nivel debe ser un entero entre 1 y 12'), nl,
            write('- Atributo debe ser un átomo (agua, fuego, viento, tierra, luz, oscuridad, divino)'), nl,
            write('- Poder debe ser un entero múltiplo de 50'), nl
        )
    ;   write('Error: Formato incorrecto. Use: mostro(nombre, nivel, atributo, poder).'), nl
    ).
