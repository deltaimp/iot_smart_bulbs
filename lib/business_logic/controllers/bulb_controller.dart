import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/loading_controller.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

import '../ui_models/ui_bulb.dart';

class BulbsController extends GetxController {
  final FakeBulbConnector _repository = FakeBulbConnector();
  final RxList<UIBulb> bulbs = <UIBulb>[].obs;

  Future<bool> checkDevice(Bulb b) {
    return _repository.pingDevice(b.id);
  }

  void removeDevice(UIBulb bulb) {
    bulb.isSelected = false;
    bulbs.removeWhere((b) => b.id == bulb.id);
    update();
  }

  void addDevice(UIBulb bulb) {
    bulb.isSelected = true;
    update();
  }

  List<UIBulb> getSelected() {
    return bulbs.where((b) => b.isSelected).toList();
  }

  Future<List<UIBulb>> loadDevices() {
    return _repository.discoverDevices()
        .then((rawBulbs) => Future.wait(rawBulbs.map((b) =>
        checkDevice(b).then((isAvailable) {
          final uiBulb = UIBulb.fromBulb(b);
          uiBulb.isAvailable = isAvailable;
          return uiBulb;
        }),
    )))
        .then((uiBulbList) {
      bulbs.value = uiBulbList;
      return uiBulbList;
    })
        .catchError((err) {
      // Gestisci l’errore (log, snackbar, ecc.)
      Get.snackbar('Errore', 'Non è stato possibile caricare i dispositivi');
      return <UIBulb>[];
    });
  }



  void toggleSelection(UIBulb bulb) {
    bulb.isSelected = !bulb.isSelected;
    update();
  }

  void clearSelection() {
    bulbs.forEach((b) => b.isSelected = false);
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
