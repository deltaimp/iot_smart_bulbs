import 'package:get/get.dart';
import 'package:iot_smart_bulbs/models/bulb.dart';
import 'package:iot_smart_bulbs/repositories/fake_bulb_repository.dart';

class BulbController extends GetxController {
  final FakeBulbRepository _repository = FakeBulbRepository();
  final RxList<Bulb> bulbs = <Bulb>[].obs;
  final RxList<Bulb> selectedBulbs =  <Bulb>[].obs;
  final RxBool isLoading = false.obs;

  @override 
  void onInit() {
    super.onInit();
    loadDevices();
  }

  Future<void> loadDevices() {
    isLoading.value = true;
    return _repository.getDevices().then((deviceList) {
      bulbs.value = deviceList;
      isLoading.value = false;
    });
  }

  Future<List<Bulb>> discoverNewDevices() {
    isLoading.value = true;
    return _repository.getAvailableDevices().then((newDevices) {
      isLoading.value = false;
      return newDevices;
    });
  }

  Future<bool> addDevice(Bulb newBulb) {
    if (bulbs.any((b) => b.name.value == newBulb.name.value)) {
      return Future.value(false);
    }

    return _repository.addDevice(newBulb)
        .then((_) => loadDevices())
        .then((_) => true);
  }

  Future<bool> removeDevice(int deviceId) {
    return _repository.removeDevice(deviceId)
        .then((_) => loadDevices())
        .then((_) => true);
  }

  void toggleSelection(Bulb bulb) {
    if (selectedBulbs.contains(bulb)) {
      selectedBulbs.remove(bulb);
    } else {
      selectedBulbs.add(bulb);
    }
  }
}