library;

import 'package:flutter/material.dart';
import 'package:quimica/tools/elemento.dart';

bool darkMode = false;
ValueNotifier<String> querySearch = ValueNotifier<String>("");

Color colorElemento(int z) {
  // Esta funcion es para los colores de los elementos

  // Hidrogeno
  if (z == 1) return const Color(0xFFE74C3C);

  // Gases nobles
  if ([2, 10, 18, 36, 54, 86, 118].contains(z)) return const Color(0xFF8E44AD);

  // Metales alcalinos
  if ([3, 11, 19, 37, 55, 87].contains(z)) return const Color(0xFFE67E22);

  // Metales alcalinotérreos
  if ([4, 12, 20, 38, 56, 88].contains(z)) return const Color(0xFFD4AC0D);

  // Lantánidos
  if (z >= 57 && z <= 71) return const Color(0xFF27AE60);

  // Actínidos
  if (z >= 89 && z <= 103) return const Color(0xFF1ABC9C);
  if ((z >= 21 && z <= 30) ||
      (z >= 39 && z <= 48) ||
      (z >= 72 && z <= 80) ||
      (z >= 104 && z <= 112)) {
    return const Color(0xFF2980B9);
  }
  // Metales post-transición
  if ([13, 31, 49, 50, 81, 82, 83, 113, 114, 115, 116].contains(z)) {
    return const Color(0xFF7F8C8D);
  }
  // Metaloides
  if ([5, 14, 32, 33, 51, 52, 85].contains(z)) return const Color(0xFF16A085);
  // No metal
  return const Color(0xFF27AE60);
}

String categoriaElemento(int z) {
  if (z == 1) return 'Hidrógeno';
  if ([2, 10, 18, 36, 54, 86, 118].contains(z)) return 'Gas noble';
  if ([3, 11, 19, 37, 55, 87].contains(z)) return 'Metal alcalino';
  if ([4, 12, 20, 38, 56, 88].contains(z)) return 'Met. alcalinotérreo';
  if (z >= 57 && z <= 71) return 'Lantánido';
  if (z >= 89 && z <= 103) return 'Actínido';
  if ((z >= 21 && z <= 30) ||
      (z >= 39 && z <= 48) ||
      (z >= 72 && z <= 80) ||
      (z >= 104 && z <= 112)) {
    return 'Metal transición';
  }
  if ([13, 31, 49, 50, 81, 82, 83, 113, 114, 115, 116].contains(z)) {
    return 'Metal post-trans.';
  }
  if ([5, 14, 32, 33, 51, 52, 85].contains(z)) return 'Metaloide';
  return 'No metal';
}

void mostrarDetalleElemento(BuildContext context, Elemento el) {
  final color = colorElemento(el.z);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      el.z.toString(),
                      style: TextStyle(fontSize: 11, color: color),
                    ),
                    Text(
                      el.s,
                      style: TextStyle(
                        fontSize: 28,
                        color: color,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      el.n,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        categoriaElemento(el.z),
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _infoRow('Descripción', el.descripcion),
                  _infoRow('N.º atómico', el.z.toString()),
                  _infoRow('Símbolo', el.s),
                  _infoRow('Config. compacta', el.cr),
                  _infoRow('Config. completa', el.cc),
                  _infoRow('Números de oxidación', el.oxidacion),
                  _infoRow('Familia', el.familia),
                  _infoRow('Grupo', el.grupo),
                  _infoRow('Periodo', el.periodo.toString()),
                  _infoRow('Estado', el.estado),
                  _infoRow('Origen', el.origen),
                  _infoRow('Propiedades', el.propiedades),
                  _infoRow('Abundancia', el.abundancia),
                  _infoRow('Produccion', el.produccion),
                  _infoRow('Extraccion', el.extraccion),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
