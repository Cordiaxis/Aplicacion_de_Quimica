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

int mcd(int a, int b) {
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

/// Deriva la raíz de nomenclatura tradicional de un elemento.
/// Si tiene nombre_tradicional en el JSON, lo usa directamente.
/// Si no, corta las terminaciones comunes del español:
///   sodio → sod, calcio → calc, hidrógeno → hidr, carbono → carbon, etc.
String getRaiz(Elemento e) {
  if (e.nombre_tradicional.isNotEmpty) return e.nombre_tradicional;
  String n = e.n.toLowerCase();
  if (n.endsWith('ígeno')) {
    return n.substring(0, n.length - 5); // hidrógeno→hidr
  }
  if (n.endsWith('geno')) {
    return n.substring(0, n.length - 4);
  }
  if (n.endsWith('io')) {
    return n.substring(0, n.length - 2); // sodio→sod, calcio→calc
  }
  if (n.endsWith('o')) {
    return n.substring(0, n.length - 1); // cloro→clor
  }
  return n; // zinc, níquel, etc.
}

enum TipoCompuesto {
  oxido,
  anhidrido,
  hidruro,
  hidracido,
  hidroxido,
  oxoacido,
  oxisal,
  salBinaria,
  covalente,
  otro,
}

class CompuestoResult {
  final String formula;
  final String tipoCompuesto;
  final String tradicional;
  final String stock;
  final String sistematica;

  CompuestoResult({
    required this.formula,
    required this.tipoCompuesto,
    required this.tradicional,
    required this.stock,
    required this.sistematica,
  });
}

class ResultadoValidacion {
  final bool valido;
  final Map<String, int> oxidaciones;

  ResultadoValidacion(this.valido, this.oxidaciones);
}
