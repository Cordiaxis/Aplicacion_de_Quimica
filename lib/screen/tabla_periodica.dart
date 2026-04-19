import 'package:flutter/material.dart';
import 'package:quimica/tools/elemento.dart';
import 'package:quimica/json/leer_json.dart';
import 'package:quimica/tools/globals.dart';

class TablaPeriodica extends StatefulWidget {
  const TablaPeriodica({super.key});

  @override
  State<TablaPeriodica> createState() => _TablaPeriodicaState();
}

class _TablaPeriodicaState extends State<TablaPeriodica> {
  List<Elemento> _elementos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final data = await leerJson();
    if (mounted) {
      setState(() {
        _elementos = data;
        _loading = false;
      });
    }
  }

  Color _colorCategoria(int z) => colorElemento(z);

  Elemento? _byZ(int z) {
    try {
      return _elementos.firstWhere((e) => e.z == z);
    } catch (_) {
      return null;
    }
  }

  static const List<(int row, int col, int z)> _positions = [
    (1, 1, 1),
    (1, 18, 2),
    (2, 1, 3),
    (2, 2, 4),
    (2, 13, 5),
    (2, 14, 6),
    (2, 15, 7),
    (2, 16, 8),
    (2, 17, 9),
    (2, 18, 10),
    (3, 1, 11),
    (3, 2, 12),
    (3, 13, 13),
    (3, 14, 14),
    (3, 15, 15),
    (3, 16, 16),
    (3, 17, 17),
    (3, 18, 18),
    (4, 1, 19),
    (4, 2, 20),
    (4, 3, 21),
    (4, 4, 22),
    (4, 5, 23),
    (4, 6, 24),
    (4, 7, 25),
    (4, 8, 26),
    (4, 9, 27),
    (4, 10, 28),
    (4, 11, 29),
    (4, 12, 30),
    (4, 13, 31),
    (4, 14, 32),
    (4, 15, 33),
    (4, 16, 34),
    (4, 17, 35),
    (4, 18, 36),
    (5, 1, 37),
    (5, 2, 38),
    (5, 3, 39),
    (5, 4, 40),
    (5, 5, 41),
    (5, 6, 42),
    (5, 7, 43),
    (5, 8, 44),
    (5, 9, 45),
    (5, 10, 46),
    (5, 11, 47),
    (5, 12, 48),
    (5, 13, 49),
    (5, 14, 50),
    (5, 15, 51),
    (5, 16, 52),
    (5, 17, 53),
    (5, 18, 54),
    (6, 1, 55),
    (6, 2, 56),
    (6, 4, 72),
    (6, 5, 73),
    (6, 6, 74),
    (6, 7, 75),
    (6, 8, 76),
    (6, 9, 77),
    (6, 10, 78),
    (6, 11, 79),
    (6, 12, 80),
    (6, 13, 81),
    (6, 14, 82),
    (6, 15, 83),
    (6, 16, 84),
    (6, 17, 85),
    (6, 18, 86),
    (7, 1, 87),
    (7, 2, 88),
    (7, 4, 104),
    (7, 5, 105),
    (7, 6, 106),
    (7, 7, 107),
    (7, 8, 108),
    (7, 9, 109),
    (7, 10, 110),
    (7, 11, 111),
    (7, 12, 112),
    (7, 13, 113),
    (7, 14, 114),
    (7, 15, 115),
    (7, 16, 116),
    (7, 17, 117),
    (7, 18, 118),
    (9, 4, 57),
    (9, 5, 58),
    (9, 6, 59),
    (9, 7, 60),
    (9, 8, 61),
    (9, 9, 62),
    (9, 10, 63),
    (9, 11, 64),
    (9, 12, 65),
    (9, 13, 66),
    (9, 14, 67),
    (9, 15, 68),
    (9, 16, 69),
    (9, 17, 70),
    (9, 18, 71),
    (10, 4, 89),
    (10, 5, 90),
    (10, 6, 91),
    (10, 7, 92),
    (10, 8, 93),
    (10, 9, 94),
    (10, 10, 95),
    (10, 11, 96),
    (10, 12, 97),
    (10, 13, 98),
    (10, 14, 99),
    (10, 15, 100),
    (10, 16, 101),
    (10, 17, 102),
    (10, 18, 103),
  ];

  Widget _cell(Elemento el) {
    final color = _colorCategoria(el.z);
    return GestureDetector(
      onTap: () => mostrarDetalleElemento(context, el),
      child: Container(
        width: 52,
        height: 56,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.88),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              el.z.toString(),
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              el.s,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            Text(
              el.n.length > 8 ? '${el.n.substring(0, 7)}.' : el.n,
              style: const TextStyle(fontSize: 7, color: Colors.white70),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCell() => const SizedBox(width: 55, height: 59);

  Widget _placeholderCell(String label, Color color) {
    return Container(
      width: 52,
      height: 56,
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.6), width: 1),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF12121F),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      );
    }
    final Map<(int, int), int> posMap = {};
    for (final (row, col, z) in _positions) {
      posMap[(row, col)] = z;
    }

    const double cellW = 55;
    const double cellH = 59;
    const int cols = 18;
    const int rows = 10;

    return Scaffold(
      backgroundColor: const Color(0xFF12121F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Tabla Periódica',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(rows, (ri) {
                    final row = ri + 1;
                    return Row(
                      children: [
                        SizedBox(
                          width: 18,
                          child: row <= 7
                              ? Text(
                                  row.toString(),
                                  style: const TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : row == 8
                              ? const SizedBox()
                              : Text(
                                  row == 9 ? 'La' : 'Ac',
                                  style: const TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        ...List.generate(cols, (ci) {
                          final col = ci + 1;
                          if (row == 8) {
                            return const SizedBox(
                              width: cellW,
                              height: cellH * 0.3,
                            );
                          }
                          if (row == 6 && col == 3) {
                            // Es la celda de los lanquimidos
                            return _placeholderCell(
                              '57–71\nLa→Lu',
                              const Color(0xFF27AE60),
                            );
                          }
                          if (row == 7 && col == 3) {
                            // Es la celda de los actinidos
                            return _placeholderCell(
                              '89–103\nAc→Lr',
                              const Color(0xFF1ABC9C),
                            );
                          }
                          final z = posMap[(row, col)];
                          if (z == null) {
                            return _emptyCell();
                          }
                          final el = _byZ(z);
                          if (el == null) {
                            return _emptyCell();
                          }
                          return _cell(el);
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    final items = [
      ('Metal alcalino', const Color(0xFFE67E22)),
      ('Met. alcalinot.', const Color(0xFFD4AC0D)),
      ('Met. transición', const Color(0xFF2980B9)),
      ('Metal post-t.', const Color(0xFF7F8C8D)),
      ('Metaloide', const Color(0xFF16A085)),
      ('No metal', const Color(0xFF27AE60)),
      ('Lantánido', const Color(0xFF27AE60)),
      ('Actínido', const Color(0xFF1ABC9C)),
      ('Gas noble', const Color(0xFF8E44AD)),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: e.$2,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      e.$1,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
