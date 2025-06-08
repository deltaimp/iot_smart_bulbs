import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Impostazioni',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Tema Scuro'),
            value: false,
            onChanged: (val) {
              // Gestisci tema
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Lingua'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Cambia lingua
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Info app'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'IoT Smart Bulbs',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025',
              );
            },
          ),
        ],
      ),
    );
  }
}
