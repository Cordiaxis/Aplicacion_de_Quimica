import 'package:flutter/material.dart';

class Aufbau extends StatefulWidget {
  const Aufbau({super.key});

  @override
  State<Aufbau> createState() => _AufbauState();
}

class _AufbauState extends State<Aufbau> {
  static const List<(int row, int col, String lvl)> _positions = [
    (1, 1, '1s'),
    (2, 1, '2s'),
    (2, 2, '2p'),
    (3, 1, '3s'),
    (3, 2, '3p'),
    (3, 3, '3d'),
    (4, 1, '4s'),
    (4, 2, '4p'),
    (4, 3, '4d'),
    (4, 4, '4f'),
    (5, 1, '5s'),
    (5, 2, '5p'),
    (5, 3, '5d'),
    (5, 4, '5f'),
    (6, 1, '6s'),
    (6, 2, '6p'),
    (6, 3, '6d'),
    (7, 1, '7s'),
    (7, 2, '7p'),
  ];
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (var (row, col, lvl) in _positions) {
      children.add(
        Positioned(
          top: row * 50.0,
          left: col * 50.0,

          child: GestureDetector(
            onTap: () {
              int electrones = 0;

              switch (lvl.substring(1)) {
                case 's':
                  electrones = 2;
                  break;
                case 'p':
                  electrones = 6;
                  break;
                case 'd':
                  electrones = 10;
                  break;
                case 'f':
                  electrones = 14;
                  break;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Puede tener hasta $electrones Electrones"),
                ),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.88),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(child: Text(lvl.toString())),
            ),
          ),
        ),
      );
    }

    // Column headers: s, p, d, f
    const colLabels = ['s', 'p', 'd', 'f'];
    for (int ci = 0; ci < colLabels.length; ci++) {
      children.add(
        Positioned(
          top: 0,
          left: (ci + 1) * 50.0,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: Text(
                colLabels[ci],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Row headers: 1–7
    for (int ri = 1; ri <= 7; ri++) {
      String Texto = '';
      switch (ri) {
        case 1:
          Texto = '1K 2';
          break;
        case 2:
          Texto = '2L 8';
          break;
        case 3:
          Texto = '3M 18';
          break;
        case 4:
          Texto = '4N 32';
          break;
        case 5:
          Texto = '5O 50';
          break;
        case 6:
          Texto = '6P 72';
          break;
        case 7:
          Texto = '7Q 98';
          break;
      }
          children.add(
            Positioned(
              top: ri * 50.0,
              left: 0,
              child: SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: Text(
                Texto,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF12121F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Principio de Aufbau',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [SizedBox(height: 400, child: Stack(children: children))],
      ),
    );
  }
}
