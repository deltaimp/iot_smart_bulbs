import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Smart Bulbs Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            Navigator.pop(context);
            // Vai alla home/dashboard
          },
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb),
          title: const Text('Tutte le Lampadine'),
          onTap: () {
            Navigator.pop(context);
            // Vai alla lista completa lampadine
          },
        ),
        /*ListTile(
          leading: const Icon(Icons.qualcosa),
          title: const Text('qualcosa'),
          onTap: () {
            Navigator.pop(context);
            // Vai alla schermata gruppi (es. stanza1, stanza2)
          },
        ),*/

      ],
    );
  }
}
