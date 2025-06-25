import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/single_bulb_controller.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;
import 'package:iot_smart_bulbs/views/screens/menu_screen.dart';
import 'package:iot_smart_bulbs/views/screens/settings_screen.dart';
import 'package:iot_smart_bulbs/views/single_bulb_screen.dart';

class BulbGridScreen extends StatelessWidget {
  final List<UIBulb> selectedBulbs;

  const BulbGridScreen({super.key, required this.selectedBulbs});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = selectedBulbs.length <= 4 ? 2 : 1;
    final childAspectRatio = selectedBulbs.length <= 4 ? 1.2 : 1.8;

    return Scaffold(
      drawer: const Drawer( // Qui metti il MenuScreen
        child: MenuScreen(),
      ),
      appBar: AppBar(
        title: const Text('Controllo Lampadine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const SettingsScreen(), // oppure un dialog o drawer a destra
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: selectedBulbs.length > 4
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          shrinkWrap: selectedBulbs.length > 4,
          itemCount: selectedBulbs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final bulb = selectedBulbs[index];
            return GetBuilder<SingleBulbController>(
              init: SingleBulbController(bulb: bulb),
              tag: 'bulb_${bulb.id}',  // <-- Qui il tag univoco
              builder: (ctrl) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GetBuilder<SingleBulbController>(
                          tag: 'bulb_${bulb.id}',  // <-- Usa stesso tag per recuperare
                          builder: (ctrl) => SingleBulbScreen(bulbId: bulb.id),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'ID: ${bulb.id}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                bulb.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Icon(
                              Icons.lightbulb,
                              size: 60,
                              color: ctrl.bulb.getColor(),
                            ),
                          ),
                          Text(
                            ctrl.bulb.isAvailable.value
                                ? 'Stato: ${ctrl.bulb.state == BulbState.ACCESA ? "Accesa" : "Spenta"}'
                                : 'Non disponibile',
                            style: TextStyle(
                              color: ctrl.bulb.isAvailable.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
