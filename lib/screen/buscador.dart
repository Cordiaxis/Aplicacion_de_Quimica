
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:quimica/json/leer_json.dart';
import 'package:quimica/screen/aufbau.dart';
import 'package:quimica/screen/creditos.dart';
import 'package:quimica/screen/tabla_periodica.dart';
import 'package:quimica/tools/elemento.dart';
import 'package:quimica/tools/globals.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var elem = await leerJson();
    setState(() {
      elementos = elem;
    });
  }

  List<Elemento> elementos = [];
  TextEditingController textFieldController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Quimica', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'Tabla periódica',
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TablaPeriodica()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            tooltip: 'Principio de Aufbau',
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Aufbau()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Créditos',
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Creditos()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: PlatformTextField(
                hintText: "Buscar elemento...",
                controller: textFieldController,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  querySearch.value = value;
                },
                material: (_, __) => MaterialTextFieldData(
                  controller: textFieldController,
                  decoration: InputDecoration(
                    hintText: "Buscar elemento...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 148, 144, 144),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        querySearch.value = "";
                        setState(() {
                          textFieldController.clear();
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                cupertino: (_, __) => CupertinoTextFieldData(
                  placeholder: "Buscar elemento...",
                  placeholderStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: textFieldController,
                  suffix: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      querySearch.value = "";
                      setState(() {
                        textFieldController.clear();
                      });
                    },
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 15, right: 10),
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  const Text(
                    "Elementos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 193, 190, 190),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      querySearch.value = "";
                      setState(() {
                        textFieldController.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkMode
                      ? const Color.fromARGB(255, 31, 31, 31)
                      : const Color.fromARGB(255, 226, 232, 238),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildListaElementos(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaElementos() {
    if (elementos.isEmpty) {
      return const Center(child: Text("No se encontraron elementos"));
    }

    return ValueListenableBuilder<String>(
      valueListenable: querySearch,
      builder: (context, searchQuery, child) {
        final Set<int> vistas = {};

        final filtrados = elementos.where((el) {
          // Si la busqueda esta vacia, no se muestra nada
          if (searchQuery.isEmpty) return false;

          // Si el elemento ya se ha visto, no se muestra
          if (vistas.contains(el.z)) return false;
          final q = searchQuery.toLowerCase();

          // Si el elemento no coincide con la busqueda, no se muestra
          if (!el.n.toLowerCase().contains(q) &&
              !el.z.toString().contains(searchQuery)) {
            return false;
          }

          // En caso de que el elemento coincida con la busqueda, se muestra
          vistas.add(el.z);
          return true;
        }).toList()..sort((a, b) => a.z.compareTo(b.z));

        // Si no se encontraron elementos, se muestra un mensaje
        if (filtrados.isEmpty) {
          return Center(
            child: Text(
              searchQuery.isNotEmpty
                  ? "No se encontraron elementos con '$searchQuery'"
                  : "Escribe para buscar un elemento",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          controller: scrollController,
          itemCount: filtrados.length,
          itemBuilder: (context, index) {
            final el = filtrados[index];
            return Column(
              children: [
                buildElementoItem(
                  context: context,
                  z: el.z,
                  n: el.n,
                  s: el.s,
                  cc: el.cc,
                  cr: el.cr,
                  grupo: el.grupo,
                  periodo: el.periodo,
                  familia: el.familia,
                  estado: el.estado,
                  descripcion: el.descripcion,
                  origen: el.origen,
                  oxidacion: el.oxidacion,
                  propiedades: el.propiedades,
                  abundancia: el.abundancia,
                  produccion: el.produccion,
                  extraccion: el.extraccion,
                ),
                if (index < filtrados.length - 1)
                  Divider(
                    height: 1,
                    color: darkMode ? Colors.grey[50] : Colors.grey[100],
                    indent: 70,
                    endIndent: 20,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
