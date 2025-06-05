import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/controllers/loading_controller.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

import '../ui_models/ui_bulb.dart';

class BulbController extends GetxController {
  final FakeBulbConnector _repository = FakeBulbConnector();
  final RxList<UIBulb> bulbs = <UIBulb>[].obs;
  final RxList<UIBulb> selectedBulbs =  <UIBulb>[].obs;
 // final RxBool isLoading = false.obs; /*andrebbe messo in un altro controller con
//  solo questavariabile, usandolo con GetBuilder e update() di GetxController
 // e ci serve per mostrare indicatore di ricerca */
  final LoadingController loadingController = Get.put(LoadingController());

  Future<bool> checkDevice(Bulb b) {
    return true.toFuture();
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

  void removeDevice(int id) {
    bulbs.removeWhere((b) => b.id == id);
    selectedBulbs.removeWhere((b) => b.id == id);
  }

  Future<List<UIBulb>> loadDevices() {
    loadingController.setLoading(true);    return _repository
        .discoverDevices()
        .then((rawBulbs) => rawBulbs.map((b) => UIBulb.fromBulb(b)).toList())
        .then((uiBulbList) {
      bulbs.value = uiBulbList;
      loadingController.setLoading(false);
      return uiBulbList;
    });
  }

  void toggleSelection(UIBulb bulb) {
    if (selectedBulbs.contains(bulb)) {
      selectedBulbs.remove(bulb);
    } else {
      selectedBulbs.add(bulb);
    }
  }

  void clearSelection() {
    selectedBulbs.clear();
  }

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


}