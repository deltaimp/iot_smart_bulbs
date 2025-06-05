import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/single_bulb_controller.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;

class BulbGridScreen extends StatelessWidget {
  final List<UIBulb> selectedBulbs;

  const BulbGridScreen({super.key, required this.selectedBulbs});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = selectedBulbs.length <= 4 ? 2 : 1;
    final childAspectRatio = selectedBulbs.length <= 4 ? 1.2 : 1.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controllo Lampadine'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Da implementare: Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Da implementare: Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
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
              builder: (ctrl) {
                return GestureDetector(
                  onTap: () {
                    // Da implementare: Navigator.push(context, MaterialPageRoute(builder: (_) => SingleBulbScreen(bulb: bulb)));
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
                              //'assets/images/single_bulb.jpg',
                              Icons.lightbulb,
                              size: 60,
                              color: ctrl.rxBulb.value.uiColor,
                            ),
                          ),
                          Text(
                            ctrl.rxBulb.value.isAvailable
                                ? 'Stato: ${ctrl.rxBulb.value.state == BulbState.ACCESA ? "Accesa" : "Spenta"}'
                                : 'Non disponibile',
                            style: TextStyle(
                              color: ctrl.rxBulb.value.isAvailable
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