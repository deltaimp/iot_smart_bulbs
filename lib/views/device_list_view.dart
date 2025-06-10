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
  final BulbsController controller = Get.find<BulbsController>();
  final LoadingController loadingController = Get.put(LoadingController());
  final IsSelectingUIController isSelectingController = IsSelectingUIController();

  void _loadDevices() {
    loadingController.setLoading(true);
    controller
        .loadDevices()
        .whenComplete(() {
      loadingController.setLoading(false);
    });
  }

  void selectingListener() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    isSelectingController.addListener(selectingListener);
    _loadDevices();
  }

  @override
  void dispose() {
    Get.delete<LoadingController>();
    loadingController.dispose();
    isSelectingController.removeListener(selectingListener);
    isSelectingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,

      drawer: const Drawer(
        child: MenuScreen(),
      ),
      appBar: AppBar(
        title: const Text('Gestione Lampadine'),
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
                  SelectDevicesButton(controller: isSelectingController, bulbController: controller,),
                  const SizedBox(height: 10),
                  GotoBulbScreenButton(controller: isSelectingController, bulbController: controller,)
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
    return GetBuilder<BulbsController>(
          builder: (ctrl) {
            final isSelected = bulb.isSelected;
            return GestureDetector(
              onTap: isSelectingController.isSelecting
                  ? () {
                if (isSelected) {
                  controller.removeDevice(bulb);
                } else {
                  controller.addDevice(bulb);
                }
              }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelectingController.isSelecting && isSelected
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
                      child: isSelectingController.isSelecting
                          ? IconButton(
                        icon: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.white : null,
                        ),
                        onPressed: () {
                          if (isSelected) {
                            controller.removeDevice(bulb);
                          } else {
                            controller.addDevice(bulb);
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
      onPressed: _loadDevices,
    );
  }
}

class IsSelectingUIController extends ChangeNotifier {
  bool _isSelecting = false;
  bool get isSelecting => _isSelecting;

  bool toggle() {
    return setSelecting(!_isSelecting);
  }

  bool setSelecting(bool s) {
    _isSelecting = s;
    notifyListeners();
    return _isSelecting;
  }
}

class SelectDevicesButton extends StatelessWidget {
  final IsSelectingUIController controller;
  final BulbsController bulbController;
  const SelectDevicesButton({
    super.key,
    required this.controller,
    required this.bulbController
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BulbsController>(
        builder: (ctrl) => ElevatedButton.icon(
          icon: const Icon(Icons.checklist),
          label: Text(controller.isSelecting
              ? "Annulla selezione"
              : "Seleziona dispositivi da controllare"),
          onPressed: () {
            if (controller.isSelecting) {
              bulbController.clearSelection();
            }
            controller.toggle();
          },
        ));
  }
}

class GotoBulbScreenButton extends StatelessWidget {
  final IsSelectingUIController controller;
  final BulbsController bulbController;
  const GotoBulbScreenButton({
    super.key,
    required this.controller,
    required this.bulbController
  });

  @override
  Widget build(BuildContext context) {
    if(!controller.isSelecting) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              final selected = bulbController.getSelected();
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) =>
                      BulbGridScreen(selectedBulbs: selected),
                ),
              )
                  .then((_) {
                bulbController.clearSelection();
                controller.setSelecting(false);
              });
            },
            child: const Text("Controlla dispositivi"),
          ),
        ],
      ),
    );
  }

}
