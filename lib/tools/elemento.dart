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
  late String oxidacion;
  late String propiedades;
  late String abundancia;
  late String produccion;
  late String extraccion;

  Elemento.fromJson(Map<String, dynamic> json) {
    z = json['z'];
    n = json['n'];
    s = json['s'];
    cc = json['cc'];
    cr = json['cr'];
    grupo = json['grupo'];
    periodo = json['periodo'];
    familia = json['familia'];
    estado = json['estado'];
    descripcion = json['descripcion'];
    origen = json['origen'];
    oxidacion = json['oxidacion'];
    propiedades = json['propiedades'];
    abundancia = json['abundancia'];
    produccion = json['produccion'];
    extraccion = json['extraccion'];
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
    required this.oxidacion,
    required this.propiedades,
    required this.abundancia,
    required this.produccion,
    required this.extraccion,
  });
}

Widget buildElementoItem({
  required BuildContext context,
  required int z,
  required String n,
  required String s,
  required String cc,
  required String cr,
  required String grupo,
  required int periodo,
  required String familia,
  required String estado,
  required String descripcion,
  required String origen,
  required String oxidacion,
  required String propiedades,
  required String abundancia,
  required String produccion,
  required String extraccion,
}) {
  return PlatformListTile(
    onTap: () {
      final el = Elemento(
        z: z,
        n: n,
        s: s,
        cc: cc,
        cr: cr,
        grupo: grupo,
        periodo: periodo,
        familia: familia,
        estado: estado,
        descripcion: descripcion,
        origen: origen,
        oxidacion: oxidacion,
        propiedades: propiedades,
        abundancia: abundancia,
        produccion: produccion,
        extraccion: extraccion,
      );
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
      n,
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
        z.toString(),
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );
}
