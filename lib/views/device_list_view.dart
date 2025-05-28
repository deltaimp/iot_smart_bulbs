import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/controllers/bulb_controller.dart';
import 'package:iot_smart_bulbs/models/bulb.dart';

class DeviceListView extends StatelessWidget {
  DeviceListView({super.key});

  final BulbController controller = Get.put(BulbController());
  final RxBool isSelecting = false.obs;
  final RxList<Bulb> tempSelectedBulbs = <Bulb>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Elenco dispositivi")),
      body: SafeArea(
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
              _buildAddDeviceButton(context),
              const SizedBox(height: 20),
              _buildSelectDevicesButton(context),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.selectedBulbs.length,
                  itemBuilder: (context, index) {
                    final bulb = controller.selectedBulbs[index];
                    return ListTile(
                      title: Text(bulb.name.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => controller.toggleSelection(bulb),
                      ),
                    );
                  },
                )),
              ),
              Obx(() => isSelecting.value ? _buildSelectionControls() : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesHeader() {
    return const Row(
      children: [
        Expanded(flex: 1, child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 3, child: Text("Nome dispositivo", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget _buildDeviceRow(Bulb bulb, BuildContext context) {
    return Obx(() {
      final isSelected = tempSelectedBulbs.contains(bulb);
      return Container(
        color: isSelecting.value && isSelected ? Colors.green.withOpacity(0.2) : Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: Text(bulb.id.toString())),
                Expanded(flex: 3, child: Obx(() => Text(bulb.name.value))),
                Expanded(
                  flex: 1,
                  child: isSelecting.value
                      ? IconButton(
                    icon: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? Colors.green : null,
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
            const Divider(),
          ],
        ),
      );
    });
  }

  Widget _buildAddDeviceButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text("Aggiungi dispositivo"),
      onPressed: () => _showAddDeviceDialog(context),
    );
  }

  void _showAddDeviceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Aggiungi dispositivo"),
        content: FutureBuilder<List<Bulb>>(
          future: controller.discoverNewDevices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final bulb = snapshot.data![index];
                  return ListTile(
                    title: Text("Dispositivo ${bulb.id}"),
                    onTap: () => _showNameDeviceDialog(context, bulb),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
        ],
      ),
    );
  }

  void _showNameDeviceDialog(BuildContext context, Bulb newBulb) {
    final nameController = TextEditingController();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Assegna nome a dispositivo ${newBulb.id}"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Nome dispositivo",
            hintText: "Inserisci un nome univoco",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Il nome non può essere vuoto")),
                );
                return;
              }

              newBulb.name.value = nameController.text.trim();
              final success = await controller.addDevice(newBulb);

              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nome già esistente")),
                );
                return;
              }

              Navigator.pop(context);
            },
            child: const Text("Salva"),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDevicesButton(BuildContext context) {
    return Obx(() => ElevatedButton.icon(
      icon: const Icon(Icons.checklist),
      label: Text(isSelecting.value ? "Annulla selezione" : "Seleziona dispositivi da controllare"),
      onPressed: () {
        if (isSelecting.value) {
          tempSelectedBulbs.clear();
        }
        isSelecting.toggle();
      },
    ));
  }

  Widget _buildSelectionControls() {
    return Obx(() => Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: tempSelectedBulbs.isEmpty
                ? null
                : () {
              controller.selectedBulbs.addAll(tempSelectedBulbs);
              tempSelectedBulbs.clear();
              isSelecting.value = false;
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Fine"),
          ),
        ],
      ),
    ));
  }
}