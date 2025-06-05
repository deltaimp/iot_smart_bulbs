import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/bulb_controller.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/loading_controller.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart';

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
    controller.loadDevices(); // Carica i dispositivi all'avvio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(title: const Text("Elenco dispositivi")),
      body: GetBuilder<LoadingController>(
        builder: (loadingController) {
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
                  const SizedBox(height: 16), // TODO
                  _buildRefreshDevicesButton(),
                  const SizedBox(height: 20),
                  _buildSelectDevicesButton(context),
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
            child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 3,
            child: Text("Nome dispositivo",
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget _buildDeviceRow(UIBulb bulb, BuildContext context) {
    return Obx(() {
      final isSelected = tempSelectedBulbs.contains(bulb);
      return Container(
        decoration: BoxDecoration(
          color: isSelecting.value && isSelected
              ? Colors.green.withOpacity(1)
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
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(flex: 1, child: Text(bulb.id.toString())),
            Expanded(
              flex: 3,
              child: Text(bulb.name, style: const TextStyle(color: Colors.white)),
            ),
            Expanded(
              flex: 1,
              child: isSelecting.value
                  ? IconButton(
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
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
                onPressed: () => controller.removeDevice(bulb.id),
              ),
            ),
          ],
        ),
      );
    });
  }

 Widget _buildRefreshDevicesButton () {
    return ElevatedButton.icon(
      icon: const Icon(Icons.refresh),
      label: const Text("Aggiorna dispositivi"),
      onPressed: () => controller.loadDevices(), // chiamata al repository
    );
 }



  Widget _buildSelectDevicesButton(BuildContext context) {
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BulbGridScreen(
                    selectedBulbs: selected,
                  ),
                ),
              ).then((_) {
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
