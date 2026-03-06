import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quimica/elemento.dart';

Future<List<Elemento>> leerJson() async {
  final String response = await rootBundle.loadString('assets/elementos_quimicos.json');
  final data = await jsonDecode(response);

  List<Elemento> elementos = [];
  for (var item in data) {
    elementos.add(Elemento.fromJson(item));
  }
  return elementos;
}
