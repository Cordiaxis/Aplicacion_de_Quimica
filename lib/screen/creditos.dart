import 'package:flutter/material.dart';

class Creditos extends StatefulWidget {
  const Creditos({super.key});

  @override
  State<Creditos> createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text('Créditos')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset('assets/tecnm.png', height: 100, width: 100,),
                  Image.asset('assets/itpn.png', height: 100, width: 100,),
              ],
            ),
            const Spacer(),
            const ListTile(
              title: Text('Aplicación Hecha por:'),
              subtitle: Text('Erick Sebastian Santibañez Cepeda'),
            ),
          ],
        ),
      ),
    );
  }
}
