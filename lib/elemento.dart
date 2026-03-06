import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:quimica/globals.dart';
import 'package:quimica/tabla_periodica.dart';

class Elemento {
  late int z;
  late String n;
  late String s;
  late String cc;
  late String cr;

  Elemento.fromJson(Map<String, dynamic> json) {
    z = json['z'];
    n = json['n'];
    s = json['s'];
    cc = json['cc'];
    cr = json['cr'];
  }

  Elemento({
    required this.z,
    required this.n,
    required this.s,
    required this.cc,
    required this.cr,
  });
}

Widget buildElementoItem({
  required BuildContext context,
  required int z,
  required String n,
  required String s,
  required String cc,
  required String cr,
}) {
  return PlatformListTile(
    onTap: () {
      final el = Elemento(z: z, n: n, s: s, cc: cc, cr: cr);
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
        color: darkMode ? Colors.white : Color(0xFF374151),
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
