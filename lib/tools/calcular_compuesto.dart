import 'package:quimica/models/compuestos.dart';
import 'package:quimica/tools/helpers/sufijos.dart';

// --- CLASIFICACIÓN DINÁMICA ---
TipoCompuesto clasificar(List<CompuestoInput?> selecciones) {
  final tieneOxigeno = selecciones.any((e) => e!.elemento!.s == 'O');
  final tieneHidrogeno = selecciones.any((e) => e!.elemento!.s == 'H');
  final metales = selecciones
      .where((e) => e!.elemento!.tipo == 'metal')
      .toList();
  final noMetales = selecciones.where((e) {
    final tipo = e!.elemento!.tipo.toLowerCase();
    return tipo.contains('no') && tipo.contains('metal');
  }).toList();

  final totalElementos = selecciones.length;

  if (totalElementos == 2) {
    if (tieneOxigeno) {
      if (metales.isNotEmpty) return TipoCompuesto.oxido;
      if (noMetales.isNotEmpty) return TipoCompuesto.anhidrido;
    }

    if (tieneHidrogeno) {
      if (metales.isNotEmpty) return TipoCompuesto.hidruro;
      return TipoCompuesto.hidracido;
    }

    if (selecciones.any((e) => e!.elemento!.esMetal) &&
        selecciones.any((e) => e!.elemento!.esNoMetal)) {
      return TipoCompuesto.salBinaria;
    }

    if (noMetales.length == 2) {
      return TipoCompuesto.covalente;
    }
  }

  if (totalElementos == 3) {
    if (tieneHidrogeno && tieneOxigeno) {
      if (metales.isNotEmpty) {
        return TipoCompuesto.hidroxido;
      }
      if (noMetales.isNotEmpty) {
        return TipoCompuesto.oxoacido;
      }
    }

    if (tieneOxigeno && metales.isNotEmpty && noMetales.isNotEmpty) {
      return TipoCompuesto.oxisal;
    }
  }

  return TipoCompuesto.otro;
}

// --- NOMENCLATURA DE STOCK ---
String nombreStock(List<CompuestoInput?> selecciones, TipoCompuesto tipo) {
  final componentes = selecciones.whereType<CompuestoInput>().toList();
  if (componentes.length < 2) return "-";

  final principal = componentes.firstWhere(
    (e) => e.elemento!.s != 'O' && e.elemento!.s != 'H',
    orElse: () => componentes.first,
  );

  final bool tieneMultiplesValencias =
      principal.elemento!.oxidaciones.where((o) => o > 0).length > 1;
  final String romanoStr = tieneMultiplesValencias
      ? " (${romano(principal.estadoOxidacion!.abs())})"
      : "";

  final String nombreEl = principal.elemento!.n;

  switch (tipo) {
    case TipoCompuesto.oxido:
    case TipoCompuesto.anhidrido:
      return "Óxido de $nombreEl$romanoStr";
    case TipoCompuesto.hidruro:
      return "Hidruro de $nombreEl$romanoStr";
    case TipoCompuesto.hidroxido:
      return "Hidróxido de $nombreEl$romanoStr";
    case TipoCompuesto.salBinaria:
      final noMetal = componentes.firstWhere(
        (e) => e.elemento!.tipo == 'no metal' || e.elemento!.forma_anion,
      );
      String anion =
          noMetal.elemento!.nombre_anion ?? "${noMetal.elemento!.n}uro";
      return "$anion de $nombreEl$romanoStr";
    case TipoCompuesto.hidracido:
      return "${principal.elemento!.nombre_anion ?? principal.elemento!.n + 'uro'} de hidrógeno";
    default:
      return "Pendiente de lógica para $tipo";
  }
}

// --- NOMENCLATURA SISTEMÁTICA ---
String nombreSistematica(
  List<CompuestoInput?> selecciones,
  TipoCompuesto tipo,
) {
  final componentes = selecciones.whereType<CompuestoInput>().toList();
  if (componentes.length < 2) return "-";

  final cat = componentes.first;
  final an = componentes.last;

  String getPrefijo(int cant) {
    if (cant == 1) return "mono";
    return prefijo(cant);
  }

  if (tipo == TipoCompuesto.hidroxido) {
    final hidrogeno = componentes.firstWhere((e) => e.elemento!.s == 'H');
    int cantOH = hidrogeno.cantidad;
    String preOH = getPrefijo(cantOH);
    return "${preOH}hidróxido de ${cat.elemento!.n.toLowerCase()}";
  }

  if (tipo == TipoCompuesto.oxoacido) {
    final oxigeno = componentes.firstWhere((e) => e.elemento!.s == 'O');
    final noMetal = componentes.firstWhere(
      (e) => e.elemento!.s != 'O' && e.elemento!.s != 'H',
    );

    String preO = getPrefijo(oxigeno.cantidad);
    String raiz = noMetal.elemento!.nombre_tradicional;
    int oxNM = noMetal.estadoOxidacion!;

    return "${preO}oxo${raiz}ato (${romano(oxNM.abs())}) de hidrógeno";
  }

  if (tipo == TipoCompuesto.oxisal) {
    final oxigeno = componentes.firstWhere((e) => e.elemento!.s == 'O');
    final noMetal = componentes.firstWhere(
      (e) => e.elemento!.s != 'O' && e.elemento!.tipo != 'metal',
    );
    final metal = componentes.firstWhere((e) => e.elemento!.tipo == 'metal');

    String preO = getPrefijo(oxigeno.cantidad);
    String raizNM = noMetal.elemento!.nombre_tradicional;
    String parteAnion =
        "${preO}oxo${raizNM}ato (${romano(noMetal.estadoOxidacion!.abs())})";

    String preCat = metal.cantidad > 1 ? prefijo(metal.cantidad) : "";
    return "$parteAnion de $preCat${metal.elemento!.n.toLowerCase()}";
  }

  String prefAn = getPrefijo(an.cantidad);
  String prefCat = cat.cantidad > 1 ? prefijo(cat.cantidad) : "";

  String nombreBaseAnion;
  if (an.elemento!.s == 'O') {
    nombreBaseAnion = "óxido";
  } else if (an.elemento!.s == 'H') {
    nombreBaseAnion = "hidruro";
  } else {
    nombreBaseAnion =
        an.elemento!.nombre_anion ?? "${an.elemento!.n.toLowerCase()}uro";
  }
  String prefijoFinal = (prefAn == "mono" && nombreBaseAnion == "óxido")
      ? "mon"
      : prefAn;

  return "${prefijoFinal}${nombreBaseAnion} de $prefCat${cat.elemento!.n.toLowerCase()}";
}

// --- NOMENCLATURA TRADICIONAL ---
String nombreTradicional(
  List<CompuestoInput?> selecciones,
  TipoCompuesto tipo,
) {
  final componentes = selecciones.whereType<CompuestoInput>().toList();
  if (componentes.length < 2) return "-";

  final principal = componentes.firstWhere(
    (e) => e.elemento!.s != 'O' && e.elemento!.s != 'H',
    orElse: () => componentes.first,
  );

  String raizModificada = getNomenclaturaTradicional(
    principal.elemento!,
    principal.estadoOxidacion!,
  );

  switch (tipo) {
    case TipoCompuesto.oxido:
      return "Óxido $raizModificada";
    case TipoCompuesto.anhidrido:
      return "Anhídrido $raizModificada";
    case TipoCompuesto.hidruro:
      return "Hidruro $raizModificada";
    case TipoCompuesto.hidroxido:
      return "Hidróxido $raizModificada";
    case TipoCompuesto.hidracido:
      return "Ácido ${principal.elemento!.nombre_tradicional}hídrico";
    case TipoCompuesto.oxoacido:
      return "Ácido $raizModificada";
    case TipoCompuesto.salBinaria:
      final metal = componentes.firstWhere(
        (e) =>
            e.elemento!.tipo.toLowerCase().contains('metal') &&
            !e.elemento!.tipo.toLowerCase().contains('no'),
        orElse: () => componentes.first,
      );

      final noMetal = componentes.firstWhere(
        (e) =>
            e.elemento!.tipo.toLowerCase().contains('no metal') ||
            e.elemento!.tipo.toLowerCase().contains('halógeno'),
        orElse: () => componentes.last,
      );
      String raizMetal = getNomenclaturaTradicional(
        metal.elemento!,
        metal.estadoOxidacion!,
      );
      String anion =
          noMetal.elemento!.nombre_anion ??
          "${noMetal.elemento!.nombre_tradicional}uro";

      return "${noMetal.elemento!.nombre_anion ?? noMetal.elemento!.nombre_tradicional + 'uro'} $raizMetal";
    default:
      return "Pendiente";
  }
}

// --- MAIN Y HELPERS ---
CompuestoResult resolver(List<CompuestoInput?> selecciones) {
  var formula = construirFormulaDesdeUI(selecciones);
  var validacion = validarCompuesto(selecciones);

  if (!validacion) {
    return CompuestoResult(
      formula: formula,
      tipoCompuesto: "INVÁLIDO",
      tradicional: "-",
      stock: "-",
      sistematica: "-",
    );
  }

  var tipo = clasificar(selecciones);

  return CompuestoResult(
    formula: formula,
    tipoCompuesto: tipo.name.toUpperCase(),
    tradicional: nombreTradicional(selecciones, tipo),
    stock: nombreStock(selecciones, tipo),
    sistematica: nombreSistematica(selecciones, tipo),
  );
}
