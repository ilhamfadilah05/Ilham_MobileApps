import 'dart:async';

import 'package:get/get.dart';

import '../../Views/Home/home_view.dart';

class SplashscreenController extends GetxController {
  var name = "Point Of Sales".obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() {
    Timer(const Duration(seconds: 1), () => Get.offAll(HomeView()));
  }
}
