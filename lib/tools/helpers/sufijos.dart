import 'package:quimica/models/compuestos.dart';
import 'package:quimica/tools/elemento.dart';

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
    if (element == null) continue;

    sumaTotal += element.cantidad * (element.estadoOxidacion as int);
  }

  return sumaTotal == 0;
}
