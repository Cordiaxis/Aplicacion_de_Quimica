import 'package:quimica/models/compuestos.dart';
import 'package:quimica/tools/helpers/sufijos.dart';

// --- CLASIFICACIÓN DINÁMICA ---
TipoCompuesto clasificar(List<CompuestoInput?> selecciones) {
  final tieneOxigeno = selecciones.any((e) => e!.elemento!.s == 'O');
  final tieneHidrogeno = selecciones.any((e) => e!.elemento!.s == 'H');
  final metales = selecciones.where((e) => e!.elemento!.esMetal).toList();
  final noMetales = selecciones.where((e) => e!.elemento!.esNoMetal).toList();

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
        (e) => e.elemento!.esNoMetal || e.elemento!.forma_anion,
      );
      
      String anion =
          noMetal.elemento!.nombre_anion ?? "${noMetal.elemento!.n}uro";
      return "$anion de $nombreEl$romanoStr";
    case TipoCompuesto.hidracido:
      return "${principal.elemento!.nombre_anion ?? principal.elemento!.n + 'uro'} de hidrógeno";
    case TipoCompuesto.oxoacido:
      final oxigeno = componentes.firstWhere((e) => e.elemento!.s == 'O');
      final noMetal = componentes.firstWhere(
        (e) => e.elemento!.s != 'O' && e.elemento!.s != 'H',
      );
      String preO = oxigeno.cantidad == 1
          ? "oxo"
          : "${prefijo(oxigeno.cantidad)}oxo";
      String raiz = noMetal.elemento!.nombre_tradicional;
      int oxNM = noMetal.estadoOxidacion!.abs();
      return "Ácido $preO${raiz}ico (${romano(oxNM)})";
    case TipoCompuesto.oxisal:
      final cation = componentes.firstWhere((e) => e.elemento!.s != 'O');
      final central = componentes.firstWhere(
        (e) => e.elemento!.s != 'O' && e.elemento!.s != cation.elemento!.s,
        orElse: () => componentes.last,
      );
      String raizAnion = getNomenclaturaTradicional(
        central.elemento!,
        central.estadoOxidacion!,
      );
      String anion = raizAnion
          .replaceAll('oso', 'ito')
          .replaceAll('ico', 'ato')
          .replaceAll('sulfurato', 'sulfato')
          .replaceAll('sulfurito', 'sulfito')
          .replaceAll('fosforato', 'fosfato')
          .replaceAll('fosforito', 'fosfito');
      return "$anion de $nombreEl$romanoStr";
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
    if (cant == 1) return "";
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
    final cation = componentes.firstWhere((e) => e.elemento!.s != 'O');
    final central = componentes.firstWhere(
      (e) => e.elemento!.s != 'O' && e.elemento!.s != cation.elemento!.s,
    );

    int divisor = mcd(central.cantidad, oxigeno.cantidad);
    int oxt = oxigeno.cantidad ~/ divisor;
    int cent = central.cantidad ~/ divisor;

    String preO = getPrefijo(oxt);
    String preCent = cent > 1 ? prefijo(cent) : "";
    String raizNM = central.elemento!.nombre_tradicional;
    
    String baseAnion = "${preO}oxo${preCent}${raizNM}ato"
        .replaceAll('sulfurato', 'sulfato')
        .replaceAll('fosforato', 'fosfato');
    String parteAnion = "$baseAnion (${romano(central.estadoOxidacion!.abs())})";

    String preCat = cation.cantidad > 1 ? prefijo(cation.cantidad) : "";
    return "$parteAnion de $preCat${cation.elemento!.n}";
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
    case TipoCompuesto.oxisal:
      final cation = componentes.firstWhere((e) => e.elemento!.s != 'O');
      final central = componentes.firstWhere(
        (e) => e.elemento!.s != 'O' && e.elemento!.s != cation.elemento!.s,
        orElse: () => componentes.last,
      );
      String raizAnion = getNomenclaturaTradicional(
        central.elemento!,
        central.estadoOxidacion!,
      );
      String anion = raizAnion
          .replaceAll('oso', 'ito')
          .replaceAll('ico', 'ato')
          .replaceAll('sulfurato', 'sulfato')
          .replaceAll('sulfurito', 'sulfito')
          .replaceAll('fosforato', 'fosfato')
          .replaceAll('fosforito', 'fosfito');
      String raizMetal = getNomenclaturaTradicional(
        cation.elemento!,
        cation.estadoOxidacion!,
      );
      return "${anion.toLowerCase()} $raizMetal";
    case TipoCompuesto.salBinaria:
      final metal = componentes.firstWhere(
        (e) => e.elemento!.esMetal,
        orElse: () => componentes.first,
      );

      final noMetal = componentes.firstWhere(
        (e) => e.elemento!.esNoMetal,
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

// --- LA FUNCION PRINCIPAL W 🗣️🗣️🗣️🗣️🗣️🗣️🗣️ ---
CompuestoResult resolver(List<CompuestoInput?> selecciones) {
  bool tumbalacasamami = selecciones.every((e) => e != null && e.estadoOxidacion != null && e.estadoOxidacion != 0);
  if (!tumbalacasamami) {
    deducirOxidaciones(selecciones);
  }

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
