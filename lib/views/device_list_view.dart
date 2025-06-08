import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/bulb_controller.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/loading_controller.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart';
import 'package:iot_smart_bulbs/views/screens/menu_screen.dart';
import 'package:iot_smart_bulbs/views/screens/settings_screen.dart';

import 'bulb_grid_screen.dart';

class DeviceListView extends StatefulWidget {
  const DeviceListView({super.key});

  @override
  _DeviceListViewState createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  final BulbController controller = Get.find<BulbController>();
  final LoadingController loadingController = Get.find();
  final RxBool isSelecting = false.obs;
  final RxList<UIBulb> tempSelectedBulbs = <UIBulb>[].obs;

  @override
  void initState() {
    super.initState();
    controller.loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,

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
      body: GetBuilder<LoadingController>(
        builder: (_) {
          if (loadingController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildDevicesHeader(),
                        const Divider(),
                        Expanded(
                          child: Obx(() => ListView.builder(
                            itemCount: controller.bulbs.length,
                            itemBuilder: (context, index) {
                              final bulb = controller.bulbs[index];
                              return _buildDeviceRow(bulb, context);
                            },
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRefreshDevicesButton(),
                  const SizedBox(height: 20),
                  _buildSelectDevicesButton(),
                  const SizedBox(height: 10),
                  Obx(() => isSelecting.value
                      ? _buildSelectionControls()
                      : const SizedBox()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDevicesHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("ID",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Expanded(
          flex: 3,
          child: Text("Nome dispositivo",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget _buildDeviceRow(UIBulb bulb, BuildContext context) {
    return Obx(() {
      final isSelected = tempSelectedBulbs.contains(bulb);
      return GestureDetector(
        onTap: isSelecting.value
            ? () {
          if (isSelected) {
            tempSelectedBulbs.remove(bulb);
          } else {
            tempSelectedBulbs.add(bulb);
          }
        }
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: isSelecting.value && isSelected
                ? Colors.green.withOpacity(0.8)
                : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1.0,
              ),
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  bulb.id.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(bulb.name,
                        style: const TextStyle(color: Colors.white)),
                    if (!bulb.isAvailable)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.cloud_off,
                            color: Colors.red, size: 16),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: isSelecting.value
                    ? IconButton(
                  icon: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.white : null,
                  ),
                  onPressed: () {
                    if (isSelected) {
                      tempSelectedBulbs.remove(bulb);
                    } else {
                      tempSelectedBulbs.add(bulb);
                    }
                  },
                )
                    : IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => controller.removeDevice(bulb),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRefreshDevicesButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.refresh),
      label: const Text("Aggiorna dispositivi"),
      onPressed: () => controller.loadDevices(),
    );
  }

  Widget _buildSelectDevicesButton() {
    return Obx(() => ElevatedButton.icon(
      icon: const Icon(Icons.checklist),
      label: Text(isSelecting.value
          ? "Annulla selezione"
          : "Seleziona dispositivi da controllare"),
      onPressed: () {
        if (isSelecting.value) {
          tempSelectedBulbs.clear();
        }
        isSelecting.toggle();
      },
    ));
  }

  Widget _buildSelectionControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: tempSelectedBulbs.isEmpty
                ? null
                : () {
              final selected = tempSelectedBulbs.toList();
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) =>
                      BulbGridScreen(selectedBulbs: selected),
                ),
              )
                  .then((_) {
                tempSelectedBulbs.clear();
                isSelecting.value = false;
              });
            },
            child: const Text("Controlla dispositivi"),
          ),
        ],
      ),
    );
  }
}
