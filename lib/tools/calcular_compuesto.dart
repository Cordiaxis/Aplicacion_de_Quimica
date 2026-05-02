import 'package:quimica/tools/elemento.dart';
import 'package:quimica/tools/helpers/sufijos.dart';

String nombreStock(Map<Elemento, int> formula, Map<String, int> oxidaciones) {
  TipoCompuesto tipo = clasificar(formula);
  var elems = formula.keys.toList()
    ..sort((a, b) => a.prioridad_formula.compareTo(b.prioridad_formula));

  if (tipo == TipoCompuesto.hidroxido) {
    var metal = elems.firstWhere((e) => e.s != 'O' && e.s != 'H');
    var ox = oxidaciones[metal.s]!;
    var oxsPositivos = metal.oxidaciones.where((o) => o > 0).toList();
    if (oxsPositivos.length > 1) {
      return "hidróxido de ${metal.n.toLowerCase()} (${romano(ox.abs())})";
    }
    return "hidróxido de ${metal.n.toLowerCase()}";
  }

  if (tipo == TipoCompuesto.oxoacido) {
    var noMetal = elems.firstWhere((e) => e.s != 'H' && e.s != 'O');
    var elO = elems.firstWhere((e) => e.s == 'O');
    var ox = oxidaciones[noMetal.s]!;
    int cantO = formula[elO]!;
    String preO = (cantO == 1) ? "mono" : prefijo(cantO);
    String raiz = getRaiz(noMetal);
    return "ácido ${preO}oxo${raiz}ico (${romano(ox.abs())})";
  }

  if (tipo == TipoCompuesto.oxisal) {
    var elO = elems.firstWhere((e) => e.s == 'O');
    var metal = elems.firstWhere((e) => e.forma_cation);
    var noMetal = elems.firstWhere((e) => e.s != 'O' && e.s != metal.s);
    var oxM = oxidaciones[metal.s]!;
    var oxNM = oxidaciones[noMetal.s]!;
    int cantO = formula[elO]!;

    String preO = (cantO == 1) ? "mono" : prefijo(cantO);
    String raizNM = getRaiz(noMetal);
    String parteAnion = "${preO}oxo${raizNM}ato (${romano(oxNM.abs())})";

    var oxsPosM = metal.oxidaciones.where((o) => o > 0).toList();
    if (oxsPosM.length > 1) {
      return "$parteAnion de ${metal.n.toLowerCase()} (${romano(oxM.abs())})";
    }
    return "$parteAnion de ${metal.n.toLowerCase()}";
  }

  if (elems.length != 2) return "-";

  var cat = elems.cast<Elemento?>().firstWhere(
    (e) => e!.forma_cation,
    orElse: () => null,
  );
  var an = elems.cast<Elemento?>().firstWhere(
    (e) => e!.forma_anion,
    orElse: () => null,
  );

  if (tipo == TipoCompuesto.hidracido) {
    var noMetal = elems.firstWhere((e) => e.s != 'H');
    String anion = noMetal.nombre_anion ?? noMetal.n.toLowerCase();
    return "$anion de hidrógeno";
  }

  if (cat == null && elems.any((e) => e.s == 'O')) {
    var positivo = elems.firstWhere((e) => e.s != 'O');
    var ox = oxidaciones[positivo.s]!;
    String anion = "óxido";
    var oxsPositivos = positivo.oxidaciones.where((o) => o > 0).toList();
    if (oxsPositivos.length > 1) {
      return "$anion de ${positivo.n.toLowerCase()} (${romano(ox.abs())})";
    }
    return "$anion de ${positivo.n.toLowerCase()}";
  }

  if (cat == null || an == null) return "-";

  var ox = oxidaciones[cat.s]!;
  String anion = an.nombre_anion ?? an.n.toLowerCase();
  var oxsMetal = cat.oxidaciones.where((o) => o > 0).toList();
  if (oxsMetal.length > 1) {
    return "$anion de ${cat.n.toLowerCase()} (${romano(ox.abs())})";
  }
  return "$anion de ${cat.n.toLowerCase()}";
}

String nombreSistematica(
  Map<Elemento, int> formula,
  Map<String, int> oxidaciones,
) {
  TipoCompuesto tipo = clasificar(formula);
  var elems = formula.keys.toList()
    ..sort((a, b) => a.prioridad_formula.compareTo(b.prioridad_formula));

  if (tipo == TipoCompuesto.hidroxido) {
    var elO = elems.firstWhere((e) => e.s == 'O');
    int cantOH = formula[elO]!;
    var metal = elems.firstWhere((e) => e.s != 'O' && e.s != 'H');
    String preOH = (cantOH == 1) ? "mono" : prefijo(cantOH);
    return "${preOH}hidróxido de ${metal.n.toLowerCase()}";
  }

  if (tipo == TipoCompuesto.oxoacido) {
    var noMetal = elems.firstWhere((e) => e.s != 'H' && e.s != 'O');
    var elO = elems.firstWhere((e) => e.s == 'O');
    var ox = oxidaciones[noMetal.s]!;
    int cantO = formula[elO]!;
    String preO = (cantO == 1) ? "mono" : prefijo(cantO);
    String raiz = getRaiz(noMetal);
    return "${preO}oxo${raiz}ato (${romano(ox.abs())}) de hidrógeno";
  }

  if (tipo == TipoCompuesto.oxisal) {
    var elO = elems.firstWhere((e) => e.s == 'O');
    var metal = elems.firstWhere((e) => e.forma_cation);
    var noMetal = elems.firstWhere((e) => e.s != 'O' && e.s != metal.s);
    var oxM = oxidaciones[metal.s]!;
    var oxNM = oxidaciones[noMetal.s]!;
    int cantO = formula[elO]!;

    String preO = (cantO == 1) ? "mono" : prefijo(cantO);
    String raizNM = getRaiz(noMetal);
    String parteAnion = "${preO}oxo${raizNM}ato (${romano(oxNM.abs())})";

    return "$parteAnion de ${metal.n.toLowerCase()} (${romano(oxM.abs())})";
  }

  if (elems.length != 2) return "-";

  var e1 = elems[0];
  var e2 = elems[1];

  int c1 = formula[e1]!;
  int c2 = formula[e2]!;

  String pref1 = prefijo(c1);
  String pref2 = prefijo(c2);
  if (c2 == 1) pref2 = "mono";

  String nombreAnion = e2.nombre_anion ?? e2.n.toLowerCase();

  return "${pref2}${nombreAnion} de ${pref1}${e1.n.toLowerCase()}";
}

String nombreTradicional(
  Map<Elemento, int> formula,
  Map<String, int> oxidaciones,
) {
  TipoCompuesto tipo = clasificar(formula);
  var elems = formula.keys.toList()
    ..sort((a, b) => a.prioridad_formula.compareTo(b.prioridad_formula));

  String obtenerSufijo(
    int ox,
    List<int> oxs,
    String raiz, [
    bool esAnion = false,
  ]) {
    String suf = "";
    String pre = "";
    if (oxs.length == 1) {
      return esAnion ? "${raiz}ato" : "${raiz}ico";
    } else if (oxs.length == 2) {
      suf = (ox == oxs.first)
          ? (esAnion ? "ito" : "oso")
          : (esAnion ? "ato" : "ico");
    } else if (oxs.length == 3) {
      if (ox == oxs.first) {
        pre = "hipo";
        suf = esAnion ? "ito" : "oso";
      } else if (ox == oxs.last) {
        suf = esAnion ? "ato" : "ico";
      } else {
        suf = esAnion ? "ito" : "oso";
      }
    } else if (oxs.length >= 4) {
      if (ox == oxs.first) {
        pre = "hipo";
        suf = esAnion ? "ito" : "oso";
      } else if (ox == oxs.last) {
        pre = "per";
        suf = esAnion ? "ato" : "ico";
      } else if (ox == oxs[1]) {
        suf = esAnion ? "ito" : "oso";
      } else {
        suf = esAnion ? "ato" : "ico";
      }
    }
    return "$pre$raiz$suf";
  }

  if (tipo == TipoCompuesto.hidroxido) {
    var metal = elems.firstWhere((e) => e.s != 'O' && e.s != 'H');
    var ox = oxidaciones[metal.s]!;
    String raiz = getRaiz(metal);
    List<int> oxsPos = metal.oxidaciones.where((o) => o > 0).toList()..sort();
    String sufMetal = obtenerSufijo(ox, oxsPos, raiz);
    return "hidróxido $sufMetal";
  }

  if (tipo == TipoCompuesto.oxoacido) {
    var noMetal = elems.firstWhere((e) => e.s != 'H' && e.s != 'O');
    var ox = oxidaciones[noMetal.s]!;
    String raiz = getRaiz(noMetal);
    List<int> oxsPos = noMetal.oxidaciones.where((o) => o > 0).toList()..sort();
    String sufNM = obtenerSufijo(ox, oxsPos, raiz);
    return "ácido $sufNM";
  }

  if (tipo == TipoCompuesto.oxisal) {
    var metal = elems.firstWhere((e) => e.forma_cation);
    var noMetal = elems.firstWhere((e) => e.s != 'O' && e.s != metal.s);
    var oxM = oxidaciones[metal.s]!;
    var oxNM = oxidaciones[noMetal.s]!;

    String raizNM = getRaiz(noMetal);
    List<int> oxsPosNM = noMetal.oxidaciones.where((o) => o > 0).toList()
      ..sort();
    String parteAnion = obtenerSufijo(oxNM, oxsPosNM, raizNM, true);

    String raizM = getRaiz(metal);
    List<int> oxsPosM = metal.oxidaciones.where((o) => o > 0).toList()..sort();
    String parteCation = obtenerSufijo(oxM, oxsPosM, raizM);

    if (oxsPosM.length == 1) {
      return "$parteAnion de ${metal.n.toLowerCase()}";
    }
    return "$parteAnion $parteCation";
  }

  if (elems.length != 2) return "-";

  var metal = elems.cast<Elemento?>().firstWhere(
    (e) => e!.forma_cation,
    orElse: () => null,
  );
  var noMetal = elems.cast<Elemento?>().firstWhere(
    (e) => e!.forma_anion,
    orElse: () => null,
  );

  if (tipo == TipoCompuesto.hidracido) {
    var nM = elems.firstWhere((e) => e.s != 'H');
    String raiz = getRaiz(nM);
    return "ácido ${raiz}hídrico";
  }

  if (metal == null && elems.any((e) => e.s == 'O')) {
    var positivo = elems.firstWhere((e) => e.s != 'O');
    var ox = oxidaciones[positivo.s]!;
    String raiz = getRaiz(positivo);
    List<int> oxs = positivo.oxidaciones.where((o) => o > 0).toList()..sort();
    String suf = obtenerSufijo(ox, oxs, raiz);
    return "anhídrido $suf";
  }

  if (metal == null || noMetal == null) return "-";

  var ox = oxidaciones[metal.s]!;
  String raiz = getRaiz(metal);
  String nombreAnion = noMetal.nombre_anion ?? noMetal.n.toLowerCase();
  List<int> oxs = metal.oxidaciones.where((o) => o > 0).toList()..sort();

  if (oxs.length == 1) return "$nombreAnion ${raiz}ico";
  String sufMetal = obtenerSufijo(ox, oxs, raiz);
  return "$nombreAnion $sufMetal";
}

CompuestoResult resolver(Map<Elemento, int> formula) {
  formula = simplificarFormula(formula);

  var validacion = validarCompuesto(formula);

  if (!validacion.valido) {
    return CompuestoResult(
      formula: construirFormula(formula),
      tipoCompuesto: "Inválido",
      tradicional: "-",
      stock: "-",
      sistematica: "-",
    );
  }

  var tipo = clasificar(formula);

  return CompuestoResult(
    formula: construirFormula(formula),
    tipoCompuesto: tipo.name,
    tradicional: nombreTradicional(formula, validacion.oxidaciones),
    stock: nombreStock(formula, validacion.oxidaciones),
    sistematica: nombreSistematica(formula, validacion.oxidaciones),
  );
}

Map<Elemento, int> simplificarFormula(Map<Elemento, int> formula) {
  if (formula.isEmpty) return formula;

  int divisor = formula.values.reduce((a, b) => mcd(a, b));

  if (divisor <= 1) return formula;

  return {for (var e in formula.entries) e.key: e.value ~/ divisor};
}

TipoCompuesto clasificar(Map<Elemento, int> formula) {
  var elems = formula.keys.toList();

  bool tieneO = elems.any((e) => e.s == "O");
  bool tieneH = elems.any((e) => e.s == "H");
  bool hayMetal = elems.any((e) => e.forma_cation);
  bool hayNoMetal = elems.any((e) => e.forma_anion);

  if (tieneO && elems.length == 2 && hayMetal) {
    return TipoCompuesto.oxido;
  }

  // Anhídrido: no-metal + O (sin metal)
  if (tieneO && elems.length == 2 && !hayMetal) {
    var otro = elems.firstWhere((e) => e.s != 'O');
    if (otro.puede_ser_anhidrido) return TipoCompuesto.anhidrido;
  }

  if (tieneH && elems.length == 2 && hayMetal) {
    return TipoCompuesto.hidruro;
  }

  // Hidrácido: H + no-metal (sin O)
  if (tieneH && elems.length == 2 && !hayMetal && !tieneO) {
    return TipoCompuesto.hidracido;
  }

  if (hayMetal && hayNoMetal && elems.length == 2) {
    return TipoCompuesto.salBinaria;
  }

  // TERNARIOS
  if (elems.length == 3) {
    if (tieneO && tieneH && hayMetal) {
      var elO = elems.firstWhere((e) => e.s == 'O');
      var elH = elems.firstWhere((e) => e.s == 'H');
      // En los hidróxidos, el número de O y H suele ser igual.
      if (formula[elO] == formula[elH]) {
        return TipoCompuesto.hidroxido;
      }
    }

    if (tieneO && tieneH && !hayMetal) {
      return TipoCompuesto.oxoacido;
    }

    if (tieneO && !tieneH && hayMetal) {
      bool hayNoMetalExtra = elems.any((e) => e.s != 'O' && e.forma_anion);
      if (hayNoMetalExtra) {
        return TipoCompuesto.oxisal;
      }
    }
  }

  return TipoCompuesto.otro;
}

Map<Elemento, int> construirFormulaDesdeUI(
  List<Elemento?> selecciones,
  List<int> contadores,
) {
  final formula = <Elemento, int>{};

  for (int i = 0; i < selecciones.length; i++) {
    final el = selecciones[i];
    final cant = contadores[i];

    if (el == null || cant <= 0) continue;

    formula[el] = (formula[el] ?? 0) + cant;
  }

  return formula;
}

ResultadoValidacion validarCompuesto(Map<Elemento, int> formula) {
  List<Elemento> elementos = formula.keys.toList();

  Map<String, int> mejorSolucion = {};

  bool encontrado = false;

  void backtrack(int index, int suma, Map<String, int> asignados) {
    if (index == elementos.length) {
      if (suma == 0) {
        mejorSolucion = Map.from(asignados);
        encontrado = true;
      }
      return;
    }

    var el = elementos[index];
    int cantidad = formula[el]!;

    for (var ox in el.oxidaciones) {
      asignados[el.s] = ox;

      backtrack(index + 1, suma + (ox * cantidad), asignados);

      asignados.remove(el.s);
    }
  }

  backtrack(0, 0, {});

  return ResultadoValidacion(encontrado, mejorSolucion);
}

String construirFormula(Map<Elemento, int> formula) {
  var elems = formula.keys.toList()
    ..sort((a, b) => a.prioridad_formula.compareTo(b.prioridad_formula));

  return elems.map((e) {
    int c = formula[e]!;
    return "${e.s}${c > 1 ? c : ""}";
  }).join();
}
