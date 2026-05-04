import 'package:quimica/tools/elemento.dart';

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

class CompuestoInput {
  Elemento? elemento;
  int cantidad;
  int? estadoOxidacion;

  CompuestoInput({this.elemento, this.cantidad = 0, this.estadoOxidacion});

  @override
  String toString() {
    return '{"elemento": ${elemento?.n}, "cantidad": $cantidad, "estadoOxidacion": $estadoOxidacion}';
  }
}
