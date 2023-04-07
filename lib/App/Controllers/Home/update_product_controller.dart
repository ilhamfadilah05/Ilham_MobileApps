import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/Alert/alert.dart';
import 'package:http/http.dart' as http;
import '../../Views/Home/home_view.dart';

class UpdateProductController extends GetxController {
  var title = "Update Produk".obs;
  var idProd = 0.obs;
  var foto = "".obs;
  final codeProd = TextEditingController();
  final namaProd = TextEditingController();
  final fotoProd = TextEditingController();
  final hargaProd = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idProd.value = prefs.getInt('idProd')!;
    codeProd.text = prefs.getString('codeProd')!;
    namaProd.text = prefs.getString('namaProd')!;
    fotoProd.text = prefs.getString('fotoProd')!;
    hargaProd.text = prefs.getString('hargaProd')!;
    foto.value = fotoProd.text;
  }

  void cekFoto(String value) {
    foto.value = value;
  }

  void validasi(BuildContext context) {
    isLoading.value = true;

    if (namaProd.text == "") {
      alertError(context, "Nama Produk Harus Di isi !");
      isLoading.value = false;
    } else if (fotoProd.text == "") {
      alertError(context, "Foto Produk Harus Di isi !");
      isLoading.value = false;
    } else if (hargaProd.text == "") {
      alertError(context, "Harga Produk Harus Di isi !");
      isLoading.value = false;
    } else {
      apiUpdateData();
    }
  }

  void apiUpdateData() async {
    // hargaProd.text = CurrencyFormat.convertToIdr(int.parse(hargaProd.text), 0);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PATCH',
        Uri.parse('https://apigenerator.dronahq.com/api/g7s7P925/TestAlan/' +
            "${idProd.value}"));
    request.body = json.encode({
      "name": "${namaProd.text}",
      "picture": "${fotoProd.text}",
      "price": hargaProd.text,
      "picture_ori": "",
      "created_at": "${DateTime.now()}"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.offAll(HomeView());
    } else {}
  }
}
