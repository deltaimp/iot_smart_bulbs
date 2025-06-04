import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/single_bulb_controller.dart' show SingleBulbController;
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart' show UIBulb;

class BulbGridScreen extends StatelessWidget {
  final List<UIBulb> selectedBulbs;

  const BulbGridScreen({super.key, required this.selectedBulbs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controlla lampadine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: selectedBulbs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final bulb = selectedBulbs[index];
            return GetBuilder<SingleBulbController>(
              init: SingleBulbController(bulb: bulb),
              builder: (ctrl) {
                return GestureDetector(
                  onTap: ctrl.togglePower,
                  child: Card(
                    color: ctrl.rxBulb.value.uiColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ctrl.rxBulb.value.name),
                          const SizedBox(height: 8),
                          Text(ctrl.rxBulb.value.isAvailable
                              ? 'Disponibile'
                              : 'Non disponibile'),
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
