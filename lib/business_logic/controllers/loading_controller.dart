import 'package:get/get.dart';

class LoadingController extends GetxController {
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }
}
