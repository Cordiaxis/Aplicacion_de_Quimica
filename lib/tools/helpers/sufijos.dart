import 'package:quimica/models/compuestos.dart';
import 'package:quimica/tools/elemento.dart';

int mcd(int a, int b) {
  while (b != 0) {
    int t = b;
    b = a % b;
    a = t;
  }
  return a.abs();
}

String romano(int n) {
  const romanos = {
    1: 'I',
    2: 'II',
    3: 'III',
    4: 'IV',
    5: 'V',
    6: 'VI',
    7: 'VII',
    8: 'VIII',
    9: 'IX',
    10: 'X',
  };

  return romanos[n] ?? n.toString();
}

String prefijo(int n) {
  const prefijos = {
    1: 'mono',
    2: 'di',
    3: 'tri',
    4: 'tetra',
    5: 'penta',
    6: 'hexa',
    7: 'hepta',
    8: 'octa',
    9: 'nona',
    10: 'deca',
    11: 'undeca',
    12: 'dodeca',
    13: 'trideca',
    14: 'tetradeca',
    15: 'pentadeca',
    16: 'hexadeca',
    17: 'heptadeca',
    18: 'octadeca',
    19: 'nonadeca',
    20: 'icosa',
  };

  if (n == 1) return ""; // opcional ocultar "mono"
  return prefijos[n] ?? "$n";
}

String getNomenclaturaTradicional(Elemento el, int oxUsada) {
  List<int> posibles = el.oxidaciones.where((n) => n > 0).toList()..sort();

  int total = posibles.length;
  int indice = posibles.indexOf(oxUsada);

  if (total <= 1) return "${el.nombre_tradicional}ico";

  if (total == 2) {
    return indice == 0
        ? "${el.nombre_tradicional}oso"
        : "${el.nombre_tradicional}ico";
  }

  if (total == 3) {
    if (indice == 0) return "hipo${el.nombre_tradicional}oso";
    if (indice == 1) return "${el.nombre_tradicional}oso";
    return "${el.nombre_tradicional}ico";
  }

  if (total == 4) {
    if (indice == 0) return "hipo${el.nombre_tradicional}oso";
    if (indice == 1) return "${el.nombre_tradicional}oso";
    if (indice == 2) return "${el.nombre_tradicional}ico";
    return "per${el.nombre_tradicional}ico";
  }

  if (total >= 5) {
    if (indice == total - 1) return "per${el.nombre_tradicional}ico";
    if (indice == total - 2) return "${el.nombre_tradicional}ico";
    if (indice == 0) return "hipo${el.nombre_tradicional}oso";
    return "${el.nombre_tradicional}oso";
  }

  return el.nombre_tradicional;
}

String construirFormulaDesdeUI(List<CompuestoInput?> selecciones) {
  selecciones.sort((a, b) {
    int cmp = a!.elemento!.prioridad_formula.compareTo(
      b!.elemento!.prioridad_formula,
    );
    if (cmp == 0) {
      return a.elemento!.electronegatividad.compareTo(
        b.elemento!.electronegatividad,
      );
    }
    return cmp;
  });

  String formulaTexto = selecciones
      .map((e) => "${e!.elemento!.s}${e.cantidad > 1 ? e.cantidad : ''}")
      .join();
  return formulaTexto;
}

bool validarCompuesto(List<CompuestoInput?> selecciones) {
  int sumaTotal = 0;

  for (var element in selecciones) {
    if (element == null || element.estadoOxidacion == null) continue;

    sumaTotal += element.cantidad * (element.estadoOxidacion as int);
  }

  return sumaTotal == 0;
}

bool deducirOxidaciones(List<CompuestoInput?> selecciones) {
  final validInputs = selecciones.whereType<CompuestoInput>().toList();
  if (validInputs.isEmpty) return false;

  List<List<int>> combinacionesValidas = [];

  void buscar(int index, List<int> actual) {
    if (index == validInputs.length) {
      int suma = 0;
      for (int i = 0; i < validInputs.length; i++) {
        suma += validInputs[i].cantidad * actual[i];
      }
      if (suma == 0) {
        combinacionesValidas.add(List.from(actual));
      }
      return;
    }

    final elemento = validInputs[index].elemento!;
    if (elemento.oxidaciones.isEmpty) {
      actual.add(0);
      buscar(index + 1, actual);
      actual.removeLast();
    } else {
      for (int ox in elemento.oxidaciones) {
        actual.add(ox);
        buscar(index + 1, actual);
        actual.removeLast();
      }
    }
  }

  buscar(0, []);

  if (combinacionesValidas.isEmpty) return false;

  List<int> mejorCombinacion = combinacionesValidas.first;

  if (combinacionesValidas.length > 1) {
    for (var comb in combinacionesValidas) {
      bool prefiereEsta = true;
      for (int i = 0; i < validInputs.length; i++) {
        final s = validInputs[i].elemento!.s;
        if (s == 'O' && comb[i] != -2) {
          prefiereEsta = false;
        }
        if (s == 'H' && comb[i] != 1 && comb[i] != -1) {
          prefiereEsta = false;
        }
      }
      if (prefiereEsta) {
        mejorCombinacion = comb;
        break;
      }
    }
  }

  for (int i = 0; i < validInputs.length; i++) {
    validInputs[i].estadoOxidacion = mejorCombinacion[i];
  }

  return true;
}
