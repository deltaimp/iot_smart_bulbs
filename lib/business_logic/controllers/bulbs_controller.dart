import 'package:get/get.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

import '../ui_models/ui_bulb.dart';

class BulbsController extends GetxController {
  final FakeBulbConnector _repository = FakeBulbConnector();
  final RxList<UIBulb> bulbs = <UIBulb>[].obs;
  final RxBool isLoading = false.obs;

  Future<bool> checkDevice(Bulb b) {
    return _repository.pingDevice(b.id);
  }

  void removeDevice(UIBulb bulb) {
    bulb.isSelected.value = false;
    bulbs.removeWhere((b) => b.id == bulb.id);
    update();
  }

  void addDevice(UIBulb bulb) {
    bulb.isSelected.value = true;
    update();
  }

  List<UIBulb> getSelected() {
    return bulbs.where((b) => b.isSelected.value).toList();
  }

  Future<List<UIBulb>> loadDevices() async {
    try {
      isLoading.value = true;
      final rawBulbs = await _repository.discoverDevices();

      final uiBulbList = await Future.wait(rawBulbs.map((b) async {
        try {
          final isAvailable = await checkDevice(b);
          final uiBulb = UIBulb.fromBulb(b);
          uiBulb.isAvailable.value = isAvailable;
          return uiBulb;
        } catch (e) {
          print("Errore in checkDevice: $e");
          return UIBulb.fromBulb(b)..isAvailable.value = false;
        }
      }));

      bulbs.value = uiBulbList;
      return uiBulbList;
    } catch (err) {
      print("Errore in loadDevices: $err");
      Get.snackbar('Errore', 'Non è stato possibile caricare i dispositivi');
      bulbs.value = []; // Reset esplicito
      return [];
    } finally {
      isLoading.value = false; // Garantisce sempre il reset
    }
  }



  void toggleSelection(UIBulb bulb) {
    bulb.isSelected.value = !bulb.isSelected.value;
    update();
  }

  void clearSelection() {
    bulbs.forEach((b) => b.isSelected.value = false);
    update();
  }
}

/* Future<List<UIBulb>> loadDevices() {
    isLoading.value = true;
    return _repository
        .discoverDevices()
        .then((deviceList) => deviceList.map((b) async {
      checkDevice(b).then((ok) {
        return ok ? b : null;
      });
    }))
        .then((deviceList) => deviceList.whereType<Bulb>().toList())
        .then((deviceList) {
      bulbs.value = deviceList;
      isLoading.value = false;
      return bulbs;
    });
  }*/
  // @override
  // void onInit() {
  //   super.onInit();
  //   // loadDevices(); // non necessariamente subito
  // }

  // Future<void> loadDevices() {
  //   isLoading.value = true;
  //   return _repository.getDevices().then((deviceList) {
  //     bulbs.value = deviceList;
  //     isLoading.value = false;
  //   });
  // }
  //
  // Future<List<Bulb>> discoverNewDevices() { //NO
  //   isLoading.value = true;
  //   return _repository.getAvailableDevices().then((newDevices) {
  //     isLoading.value = false;
  //     return newDevices;
  //   });
  // }
  //
  // Future<bool> removeDevice(int deviceId) {
  //   return _repository.removeDevice(deviceId)
  //       .then((_) => loadDevices())
  //       .then((_) => true);
  // }
  //
  // void toggleSelection(Bulb bulb) {
  //   if (selectedBulbs.contains(bulb)) {
  //     selectedBulbs.remove(bulb);
  //   } else {
  //     selectedBulbs.add(bulb);
  //   }
  // }
