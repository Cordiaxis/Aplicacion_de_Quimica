import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:quimica/tools/globals.dart';

class Elemento {
  late int z;
  late String n;
  late String s;
  late String cc;
  late String cr;
  late String grupo;
  late int periodo;
  late String familia;
  late String estado;
  late String descripcion;
  late String origen;
  late String propiedades;
  late String abundancia;
  late String produccion;
  late String extraccion;
  late String nombre_tradicional;

  late String tipo;
  late List<int> oxidaciones;
  late List<int> valencias_comunes;
  late bool usa_tradicional;
  late String? nombre_anion;
  late String? nombre_sistematico;
  late double electronegatividad;
  late bool es_diatomico;
  late bool forma_cation;
  late bool forma_anion;
  late bool puede_formar_oxoacidos;
  late bool puede_ser_anhidrido;
  late int prioridad_formula;
  late List<String> excepciones;
  bool get esMetal =>
      tipo.toLowerCase().contains('metal') &&
      !tipo.toLowerCase().contains('no');
  bool get esNoMetal =>
      tipo.toLowerCase().contains('no metal') || s == 'Cl' || s == 'Br'; // etc

  Elemento.fromJson(Map<String, dynamic> json) {
    z = json['z'];
    n = json['n'];
    s = json['s'];
    cc = json['cc'];
    cr = json['cr'];
    grupo = json['grupo']?.toString() ?? 'N/A';
    periodo = json['periodo'];
    familia = json['familia'];
    estado = json['estado'];
    descripcion = json['descripcion'];
    origen = json['origen'];
    propiedades = json['propiedades'];
    abundancia = json['abundancia'];
    produccion = json['produccion'];
    extraccion = json['extraccion'];
    nombre_tradicional = json['nombre_tradicional'] ?? "";
    tipo = json['tipo'] ?? 'metal';
    oxidaciones =
        (json['oxidaciones'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [];
    valencias_comunes =
        (json['valencias_comunes'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [];
    usa_tradicional = json['usa_tradicional'] ?? false;
    nombre_anion = json['nombre_anion'];
    nombre_sistematico = json['nombre_sistematico'];
    electronegatividad = (json['electronegatividad'] as num?)?.toDouble() ?? 0;
    es_diatomico = json['es_diatomico'] ?? false;
    forma_cation = json['forma_cation'] ?? false;
    forma_anion = json['forma_anion'] ?? false;
    puede_formar_oxoacidos = json['puede_formar_oxoacidos'] ?? false;
    puede_ser_anhidrido = json['puede_ser_anhidrido'] ?? false;
    prioridad_formula = json['prioridad_formula'] ?? 5;
    excepciones =
        (json['excepciones'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  Elemento({
    required this.z,
    required this.n,
    required this.s,
    required this.cc,
    required this.cr,
    required this.grupo,
    required this.periodo,
    required this.familia,
    required this.estado,
    required this.descripcion,
    required this.origen,
    required this.propiedades,
    required this.abundancia,
    required this.produccion,
    required this.extraccion,
    required this.nombre_tradicional,
    this.tipo = 'metal',
    this.oxidaciones = const [],
    this.valencias_comunes = const [],
    this.usa_tradicional = false,
    this.nombre_anion,
    this.nombre_sistematico,
    this.electronegatividad = 0,
    this.es_diatomico = false,
    this.forma_cation = false,
    this.forma_anion = false,
    this.puede_formar_oxoacidos = false,
    this.puede_ser_anhidrido = false,
    this.prioridad_formula = 5,
    this.excepciones = const [],
  });
  String get oxidacionesDisplay {
    if (oxidaciones.isEmpty) return '0';
    return oxidaciones.map((v) => v > 0 ? '+$v' : '$v').join(', ');
  }
}

Widget buildElementoItem({
  required BuildContext context,
  required Elemento el,
}) {
  return PlatformListTile(
    onTap: () {
      mostrarDetalleElemento(context, el);
    },
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.map_outlined, color: Colors.blueGrey, size: 20),
    ),
    title: Text(
      el.n,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: darkMode ? Colors.white : const Color(0xFF374151),
      ),
    ),
    trailing: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        el.z.toString(),
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );
}
