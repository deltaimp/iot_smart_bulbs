import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/single_bulb_controller.dart' show SingleBulbController;
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;
import 'package:iot_smart_bulbs/views/screens/menu_screen.dart';
import 'package:iot_smart_bulbs/views/screens/settings_screen.dart';

class SingleBulbScreen extends StatelessWidget {
  final int bulbId;

  const SingleBulbScreen({super.key, required this.bulbId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleBulbController>(
      tag: 'bulb_$bulbId',  // <-- Recupera il controller con il tag
      builder: (ctrl) {
        return Scaffold(
          drawer: const Drawer(child: MenuScreen()),
          appBar: AppBar(
            title: Text(ctrl.bulb.name), // nome lampadina
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => const SettingsScreen(),
                ),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBulbWithColorPicker(ctrl), // lampadina con selezione colore
                  const SizedBox(height: 40),
                  _buildBrightnessSlider(ctrl), // slider luminosità
                  const SizedBox(height: 20),
                  _buildPowerSwitch(ctrl), // bottone on/off
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBulbWithColorPicker(SingleBulbController ctrl) {
    return GestureDetector(
      onTap: () => _showColorPicker(ctrl),
      child: Obx(() {
        return Column(
          children: [
            Icon(
              Icons.lightbulb,
              size: 120,
              color: ctrl.bulb.state.value == BulbState.ACCESA
                  ? ctrl.bulb.getColor()
                  : Colors.grey[300],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ctrl.bulb.uiColor.value,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black38),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBrightnessSlider(SingleBulbController ctrl) {
    return Obx(() {
      return Column(
        children: [
          const Text('Luminosità'),
          Slider(
            value: ctrl.bulb.brightness.value,
            onChanged: ctrl.setBrightness,
          ),
        ],
      );
    });
  }

  Widget _buildPowerSwitch(SingleBulbController ctrl) {
    return Obx(() {
      return SwitchListTile(
        title: const Text('Accesa/Spenta'),
        value: ctrl.bulb.state.value == BulbState.ACCESA,
        onChanged: (_) => ctrl.togglePower(),
      );
    });
  }

  void _showColorPicker(SingleBulbController ctrl) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scegli colore'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: ctrl.bulb.uiColor.value,
              onColorChanged: ctrl.changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Get.back(),
            ),
          ],
        );
      },
    );
  }
}
