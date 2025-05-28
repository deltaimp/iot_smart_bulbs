import 'package:get/get.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

class BulbController extends GetxController {
  final FakeBulbConnector _repository = FakeBulbConnector();
  final RxList<Bulb> bulbs = <Bulb>[].obs;
  // final RxList<Bulb> selectedBulbs =  <Bulb>[].obs;
  final RxBool isLoading = false.obs; /*andrebbe messo in un altro controller con
  solo questavariabile, usandolo con GetBuilder e update() di GetxController
  e ci serve per mostrare indicatore di ricerca */

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
  // Future<bool> addDevice(Bulb newBulb) { //NO, USER NON PUO' AGGIUNGERE "MANUALMENTE"
  //   if (bulbs.any((b) => b.name.value == newBulb.name.value)) {
  //     return Future.value(false);
  //   }
  //
  //   return _repository.addDevice(newBulb)
  //       .then((_) => loadDevices())
  //       .then((_) => true);
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

  Future<bool> checkDevice(Bulb b) {
    return true.toFuture();
  }

  Future<List<Bulb>> loadDevices() {
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
  }
}