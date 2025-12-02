# Proyecto II: Mundo Chiquito

## Laboratorio de Lenguajes de Programación (CI-3661)
**Universidad Simón Bolívar**
**Septiembre-Diciembre 2025**

## Integrantes del Equipo

- **Nombre:** Eliezer Cario
  **Carnet:** 18-10605

- **Nombre:** Angel Rodriguez
  **Carnet:** 15-11669

## Descripción del Proyecto

Este proyecto implementa en Prolog la lógica de la carta "Mundo Chiquito" del juego de cartas coleccionables "Duelo de cartas de mostro". La carta permite encadenar mostros que compartan exactamente una característica (nivel, poder o atributo).

## Estructura de Datos

Cada mostro se representa con el predicado:
```prolog
mostro(nombre, nivel, atributo, poder).
```

Donde:
- `nombre`: átomo único que identifica al mostro
- `nivel`: entero entre 1 y 12
- `atributo`: átomo (agua, fuego, viento, tierra, luz, oscuridad, divino)
- `poder`: entero múltiplo de 50

## Predicados Implementados

### 1. `comparteExactamenteUna/2`
Predicado auxiliar que verifica si dos mostros comparten exactamente una característica (nivel, poder o atributo).

**Implementación:**
- Extrae las características de ambos mostros de la base de conocimiento
- Cuenta cuántas características son iguales
- Retorna verdadero solo si exactamente una característica coincide

### 2. `ternaMundoChiquito/3`
Predicado principal que encuentra todas las ternas válidas de mostros `(X, Y, Z)` que satisfacen las condiciones de la carta "Mundo Chiquito":
- `X`: mostro revelado de la mano
- `Y`: mostro revelado del mazo (comparte exactamente 1 característica con X)
- `Z`: mostro agregado del mazo a la mano (comparte exactamente 1 característica con Y)

**Implementación:**
- Utiliza backtracking de Prolog para generar todas las combinaciones posibles
- Verifica que X e Y compartan exactamente una característica
- Verifica que Y y Z compartan exactamente una característica
- Permite que los mostros se repitan (para simular múltiples copias en el mazo)

### 3. `mundoChiquito/0`
Imprime por consola todas las ternas válidas, una por línea, con los nombres separados por espacios.

**Implementación:**
- Utiliza `forall/2` para iterar sobre todas las soluciones de `ternaMundoChiquito/3`
- Imprime cada terna en formato: "nombre1 nombre2 nombre3"

### 4. `agregarMostro/0`
Permite agregar dinámicamente un nuevo mostro a la base de conocimiento.

**Implementación:**
- Lee un término Prolog desde la consola usando `read/1`
- Valida que el formato sea correcto: `mostro(nombre, nivel, atributo, poder)`
- Verifica las restricciones:
  - Nombre debe ser un átomo
  - Nivel debe ser entero entre 1 y 12
  - Atributo debe ser un átomo
  - Poder debe ser múltiplo de 50
- Usa `assertz/1` para agregar el mostro a la base de conocimiento si es válido

## Uso

### Cargar el archivo
```bash
swipl -s mundo_chiquito.pl
```

### Consultar todas las ternas válidas
```prolog
?- mundoChiquito.
```

### Consultar ternas específicas
```prolog
?- ternaMundoChiquito(mostroUno, Y, Z).
```

### Agregar un nuevo mostro
```prolog
?- agregarMostro.
```
Luego seguir las instrucciones e ingresar el mostro en formato:
```prolog
mostro(dragonBlanco, 8, luz, 3000).

### Listar todos los mostros
```prolog
listarMostros.

```
### Ejemplo de Ejecución

Con los mostros de ejemplo:
```prolog
mostro(mostroUno, 5, luz, 2100).
mostro(mostroDos, 7, luz, 2400).
mostro(mostroTres, 7, viento, 2500).
```

El predicado `mundoChiquito/0` produce:
```
mostroUno mostroDos mostroUno
mostroUno mostroDos mostroTres
mostroDos mostroUno mostroDos
mostroDos mostroTres mostroDos
mostroTres mostroDos mostroUno
mostroTres mostroDos mostroTres
```

## Consideraciones de Diseño

1. **Exactamente una característica:** El predicado `comparteExactamenteUna/2` cuenta las características compartidas y solo retorna verdadero si el total es exactamente 1.

2. **Mostros repetidos:** El sistema permite que un mismo mostro aparezca múltiples veces en una terna, simulando que un jugador puede tener copias de la misma carta en su mazo.

3. **Base de conocimiento dinámica:** Se usa la directiva `:- dynamic mostro/4.` para permitir agregar mostros dinámicamente durante la ejecución.

4. **Validación robusta:** El predicado `agregarMostro/0` valida exhaustivamente la entrada del usuario para evitar datos inconsistentes.
