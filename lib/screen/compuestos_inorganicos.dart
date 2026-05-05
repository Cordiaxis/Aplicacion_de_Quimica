import 'package:count_button/count_button.dart';
import 'package:flutter/material.dart';
import 'package:quimica/json/leer_json.dart';
import 'package:quimica/models/compuestos.dart';
import 'package:quimica/tools/calcular_compuesto.dart';
import 'package:quimica/tools/elemento.dart';
import 'package:quimica/tools/globals.dart';

class CompuestosInorganicos extends StatefulWidget {
  const CompuestosInorganicos({super.key});

  @override
  State<CompuestosInorganicos> createState() => CompuestosInorganicosState();
}

class CompuestosInorganicosState extends State<CompuestosInorganicos> {
  List<Elemento> elementos = [];

  final List<CompuestoInput> _selecciones = [CompuestoInput()];
  List<CompuestoResult> resultados = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var elem = await leerJson();
    elem.sort((a, b) => a.z.compareTo(b.z));
    setState(() {
      elementos = elem;
    });
  }

  Elemento? _byZ(int z) {
    try {
      return elementos.firstWhere((e) => e.z == z);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compuestos inorgánicos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: darkMode
                    ? [
                        const Color.fromARGB(255, 112, 119, 138),
                        const Color(0xFF0F3460),
                      ]
                    : [Colors.white, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Selecciona los elementos químicos para crear el compuesto:",
                    style: TextStyle(
                      color: darkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < _selecciones.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: buildBoxAtomos(i),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selecciones.add(CompuestoInput());
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Agregar elemento"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkMode
                          ? const Color(0xFF0F3460)
                          : Colors.blueGrey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final res = resolver(_selecciones);

                      setState(() {
                        resultados = [res];
                      });
                      if (resultados.isEmpty) {
                        print(
                          "No se pudo formar un compuesto con los elementos seleccionados.",
                        );
                        return;
                      }
                      for (final r in resultados) {
                        print('─── ${r.tipoCompuesto} ───');
                        print('Fórmula: ${r.formula}');
                        print('Tradicional: ${r.tradicional}');
                        print('Stock: ${r.stock}');
                        print('Sistemática: ${r.sistematica}');
                        print('');
                      }
                    },
                    icon: const Icon(Icons.calculate),
                    label: const Text("Calcular"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkMode
                          ? const Color(0xFF0F3460)
                          : Colors.blueGrey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     print("${_selecciones.map((e) => e.toString())}");
                  //   },
                  //   label: const Text("Log"),
                  // ),
                  if (resultados.isNotEmpty)
                    Column(
                      children: resultados.map((r) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0f172a),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "RESULTADO",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 100,
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  r.formula,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF334155),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "SISTEMATICA",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      r.sistematica,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(
                                      color: Color(0xff5077A7),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "TRADICIONAL",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      r.tradicional,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(
                                      color: Color(0xff5077A7),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "STOCK",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      r.stock,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(
                                      color: Color(0xff5077A7),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "TIPO DE COMPUESTO",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      r.tipoCompuesto,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBoxAtomos(int index) {
    final selected = _selecciones[index];

    return Container(
      decoration: BoxDecoration(
        color: darkMode
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  "ELEMENTO ${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 112, 111, 111),
                  ),
                ),
                const Spacer(),
                if (_selecciones.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selecciones.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Dropdown row
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selected.elemento?.z,
                    items: elementos
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e.z,
                            child: Text(
                              "${e.s} - ${e.n} (${e.oxidacionesDisplay})",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),

                    onChanged: (int? value) {
                      if (value != null) {
                        var a = _byZ(value);
                        if (a != null) {
                          print("Actualizando: ${a.s}");
                          setState(() {
                            selected.elemento = a;
                            selected.estadoOxidacion = 0;
                          });
                        }
                      }
                    },
                    hint: const Text(
                      "Selecciona un elemento",
                      style: TextStyle(color: Colors.black54),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    underline: Container(height: 1, color: Colors.black26),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Atom counter row
            Row(
              children: [
                const SizedBox(width: 4),
                const Text(
                  "ÁTOMOS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 112, 111, 111),
                  ),
                ),
                /* if (selected.elemento != null && selected.elemento!.n != "")
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selected.estadoOxidacion == 0 ? null : selected.estadoOxidacion,
                        items: selected.elemento!.oxidaciones.map((e) {
                          return DropdownMenuItem<int>(
                            value: e,
                            child: Text(e.toString()),
                          );
                        }).toList(),

                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              selected.estadoOxidacion = value;
                            });
                          }
                        },
                        hint: const Text(
                          "Selecciona oxidación",
                          style: TextStyle(color: Colors.black54),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        underline: Container(height: 1, color: Colors.black26),
                        dropdownColor: Colors.white,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ), */
                if (selected.elemento == null || selected.elemento!.n == "")
                  const Spacer()
                else
                  const Spacer(),
                CountButton(
                  selectedValue: selected.cantidad,
                  minValue: 0,
                  maxValue: 99,
                  backgroundColor: darkMode
                      ? const Color(0xFF0F3460)
                      : const Color(0xFFE0E0E0),
                  foregroundColor: darkMode ? Colors.white : Colors.black,
                  onChanged: (value) {
                    setState(() {
                      selected.cantidad = value;
                    });
                  },
                  borderRadius: 16,
                  valueBuilder: (value) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 20.0),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
