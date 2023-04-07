import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrukController extends GetxController {
  var title = "Struk Pembayaran".obs;
  var cartList = [].obs;
  var totalBayar = "".obs;
  var uangDibayar = "".obs;
  var uangKembalian = "".obs;
  var noInvoice = "".obs;
  var randomNum = 0.obs;
  var rng = Random().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    int min = 1000;
    randomNum.value = min + rng.value.nextInt(1000);
    noInvoice.value =
        "INV_${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}_${randomNum}";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartList.value = jsonDecode(prefs.getString('cartList')!);
    totalBayar.value = prefs.getString('totalBayar')!;
    uangDibayar.value = prefs.getString('uangDibayar')!;
    uangKembalian.value = prefs.getString('uangKembalian')!;
  }
}
