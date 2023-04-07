import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sales/App/Components/Alert/alert.dart';
import 'package:point_of_sales/App/Components/Currency/currency_format.dart';
import 'package:point_of_sales/App/Views/Home/home_view.dart';

class AddProductController extends GetxController {
  var title = "Tambah Produk".obs;
  var rng = Random().obs;
  var foto = "".obs;
  var randomNum = 0.obs;

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
    int min = 1000;
    randomNum.value = min + rng.value.nextInt(1000);
    codeProd.text = "FOOD-$randomNum";
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
      apiPostData();
    }
  }

  void apiPostData() async {
    // hargaProd.text = CurrencyFormat.convertToIdr(int.parse(hargaProd.text), 0);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://apigenerator.dronahq.com/api/g7s7P925/TestAlan'));
    request.body = json.encode({
      "food_code": "FOOD-$randomNum",
      "name": "${namaProd.text}",
      "picture": "${fotoProd.text}",
      "price": hargaProd.text,
      "picture_ori": "",
      "created_at": "${DateTime.now()}"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      Get.offAll(HomeView());
      isLoading.value = false;
    } else {}
  }
}
