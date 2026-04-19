import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Creditos extends StatelessWidget {
  const Creditos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Fondo principal
      appBar: AppBar(
        title: const Text(
          'Créditos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Elementos decorativos de fondo

          // la bola morada de arriba a la derecha
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurpleAccent.withOpacity(0.3),
              ),
            ),
          ),
          // la bola azul de abajo a la izquierda
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
          ),
          // Efecto de desenfoque
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox(),
            ),
          ),
          // Contenido principal
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildLogo('assets/tecnm.png'),
                                    Container(
                                      width: 2,
                                      height: 60,
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    _buildLogo('assets/itpn.png'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Mi Nombre
                              const Text(
                                'Desarrollado por',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Erick Sebastian\nSantibañez Cepeda',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 10),
                              Divider(
                                color: Colors.white.withOpacity(0.15),
                                thickness: 1.5,
                              ),
                              const SizedBox(height: 10),

                              // Datos mios y de la carrera
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Numero de Control',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          '25430120',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Carrera',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Ingeniería en Sistemas\nComputacionales',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: Colors.white.withOpacity(0.15),
                                thickness: 1.5,
                              ),
                              const SizedBox(height: 10),

                              // La seccion de cuando y donde se creo
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Fecha de Creación',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          '18 de Abril\ndel 2026',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Lugar de Desarrollo',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Instituto Tecnológico\nde Piedras Negras',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: Colors.white.withOpacity(0.15),
                                thickness: 1.5,
                              ),
                              const SizedBox(height: 10),

                              // La seccion de materia y maestro
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Materia',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'QUÍMICA',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Maestro',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'ING. PEDRO \nCRUZ VÁZQUEZ',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // El boton de donaciones
                              const SizedBox(height: 30),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                      'https://link.mercadopago.com.mx/erickssc902',
                                    );
                                    if (!await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      debugPrint('No se pudo abrir el enlace');
                                    }
                                  },
                                  child: Ink(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Donaciones',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String path) {
    return Image.asset(
      path,
      height: 80,
      width: 80,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
      },
    );
  }
}
