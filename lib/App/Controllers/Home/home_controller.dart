// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/App/Components/Alert/alert.dart';
import 'package:point_of_sales/App/Models/Home/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sales/App/Services/Home/home_service.dart';
import 'package:point_of_sales/App/Views/Home/home_view.dart';
import 'package:point_of_sales/App/Views/Home/struk_view.dart';
import 'package:point_of_sales/App/Views/Home/update_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/Currency/currency_format.dart';
import '../../Components/Widget/Text/text_stye.dart';

class HomeController extends GetxController {
  var title = "Point Of Sales".obs;
  var cartList = [].obs;
  var cartCountProduct = [].obs;
  var hargaTotal = 0.obs;
  var nameProd = [].obs;
  final uangBayar = TextEditingController();
  var uangKembalian = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void tapOrder(int id, String foodCode, String name, String picture,
      String createAt, String harga, int qty) async {
    if (cartList.length == 0) {
      cartList.add({
        "id": id,
        "food_code": foodCode,
        "name": name,
        "picture": picture,
        "created_at": createAt,
        "price": harga,
        "qty": qty,
        "total_harga": int.parse(harga) * qty
      });
      nameProd.add(name);
      hargaTotal.value = hargaTotal.value + int.parse(harga);
    } else {
      if (nameProd.contains(name)) {
        var check = cartList.firstWhere((element) => element['name'] == name);
        if (check != null) {
          check['qty'] = check['qty'] + 1;
        }
        print(cartList);
        hargaTotal.value = hargaTotal.value + int.parse(harga);
      } else {
        cartList.add({
          "id": id,
          "food_code": foodCode,
          "name": name,
          "picture": picture,
          "created_at": createAt,
          "price": harga,
          "qty": qty,
          "total_harga": int.parse(harga) * qty
        });
        nameProd.add(name);
        hargaTotal.value = hargaTotal.value + int.parse(harga);
      }
    }
  }

  void changeQtyPlus(String name, String harga, int qty) {
    var check = cartList.firstWhere((element) => element['name'] == name);
    if (check != null) {
      check['qty'] = check['qty'] + 1;
    }
    print(cartList);
    hargaTotal.value = hargaTotal.value + int.parse(harga);
  }

  void changeQtyMin(String name, String harga, int qty) {
    if (qty == 1) {
      cartList.removeWhere((item) => item['name'] == name);
      nameProd.removeWhere((item) => item == name);

      hargaTotal.value = hargaTotal.value - int.parse(harga);
    } else {
      var check = cartList.firstWhere((element) => element['name'] == name);
      if (check != null) {
        check['qty'] = check['qty'] - 1;
      }
      print(cartList);
      hargaTotal.value = hargaTotal.value - int.parse(harga);
    }
  }

  void bottomSheet() {
    Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
      return Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textDefault("Keranjang", Colors.black, 20, FontWeight.normal),
                InkWell(
                    onTap: () => Get.back(), child: Icon(Icons.cancel_outlined))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                          Positioned(
                            bottom: 9,
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.only(left: 20, bottom: 0),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: textDefault("${cartList.length}",
                                  Colors.white, 12, FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      textDefault(
                          "Rp. ${CurrencyFormat.convertToIdr(hargaTotal.value, 0)}",
                          Colors.black,
                          16,
                          FontWeight.bold)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: textDefault(
                        "Charge", Colors.white, 14, FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                itemCount: cartList.length,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  var data = cartList[i];
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data['picture'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textDefault((data['name']), Colors.black, 14,
                                    FontWeight.bold),
                                Row(
                                  children: [
                                    textDefault(
                                        ("Rp. " +
                                            "${CurrencyFormat.convertToIdr(int.parse(data['price']), 0)}"),
                                        Colors.blue[800]!,
                                        14,
                                        FontWeight.bold),
                                    textDefault('/porsi', Colors.grey, 14,
                                        FontWeight.normal),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                changeQtyMin(
                                    data['name'], data['price'], data['qty']);
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.blue[800]!)),
                                child: textDefault("-", Colors.blue[800]!, 14,
                                    FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: textDefault("${data['qty']}", Colors.black,
                                  14, FontWeight.normal),
                            ),
                            InkWell(
                              onTap: () {
                                changeQtyPlus(
                                    data['name'], data['price'], data['qty']);
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: textDefault(
                                    "+", Colors.white, 14, FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      );
    }));
  }

  void kembalian(String value) {
    if (value == "") {
      uangKembalian.value = 0 - hargaTotal.value;
    } else {
      uangKembalian.value = int.parse(value) - hargaTotal.value;
    }
  }

  void dialogPembayaran(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.all(0),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/eat.png',
                  width: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                textDefault(
                    "Detail Pesanan", Colors.blue[800]!, 18, FontWeight.bold)
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 1,
              ),
            ),
          ],
        ),
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: 100,
            clipBehavior: Clip.hardEdge,
            // padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.builder(
                      itemCount: cartList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        var data = cartList[i];
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['picture'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textDefault((data['name']), Colors.black,
                                          14, FontWeight.bold),
                                      Row(
                                        children: [
                                          textDefault(
                                              ("Rp. " +
                                                  "${CurrencyFormat.convertToIdr(int.parse(data['price']), 0)}"),
                                              Colors.blue[800]!,
                                              14,
                                              FontWeight.bold),
                                          textDefault('/porsi', Colors.grey, 14,
                                              FontWeight.normal),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              textDefault("X" + "${data['qty']}", Colors.black,
                                  14, FontWeight.bold)
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textDefault(
                            "Total :", Colors.black, 14, FontWeight.bold),
                        textDefault(
                            "Rp. ${CurrencyFormat.convertToIdr(hargaTotal.value, 0)}",
                            Colors.black,
                            14,
                            FontWeight.bold)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textDefault("Uang Dibayar : Rp. ", Colors.black, 14,
                            FontWeight.bold),
                        Expanded(
                            child: TextFormField(
                          controller: uangBayar,
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            kembalian(value);
                            setState(() {});
                          },
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textDefault("Uang Kembalian :", Colors.black, 14,
                            FontWeight.bold),
                        textDefault(
                            "Rp. ${CurrencyFormat.convertToIdr(uangKembalian.value, 0)}",
                            Colors.black,
                            14,
                            FontWeight.bold)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: [
          InkWell(
            onTap: () {
              if (hargaTotal == 0) {
                alertError(context, "Keranjang kosong !");
                Get.back();
              } else if (uangBayar.text == "") {
                alertError(context, "Uang dibayar harus di isi !");
              } else if (int.parse(uangBayar.text) < hargaTotal.value) {
                alertError(context, "Uang dibayar kurang !");
              } else {
                cetakStruk();
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: textDefault(
                      "Cetak Struk", Colors.white, 14, FontWeight.normal),
                )),
          )
        ],
      ),
    );
  }

  void cetakStruk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cartList', jsonEncode(cartList.value));
    prefs.setString('totalBayar', "${hargaTotal.value}");
    prefs.setString('uangDibayar', "${uangBayar.text}");
    prefs.setString('uangKembalian', "${uangKembalian.value}");
    Get.offAll(StrukView());
  }

  void dialogDeleteProduct(BuildContext context, String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Icon(
          Icons.help_outline,
          size: 50,
          color: Colors.red,
        ),
        content: Text(
          "Apakah anda ingin menghapus product ini ?",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'poppins'),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Tidak",
              style: TextStyle(fontFamily: 'poppins'),
            ),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "Ya, Hapus",
              style: TextStyle(fontFamily: 'poppins'),
            ),
            onPressed: () => apiDeleteData(context, id),
          ),
        ],
      ),
    );
  }

  apiDeleteData(BuildContext context, String id) async {
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://apigenerator.dronahq.com/api/g7s7P925/TestAlan/' + id));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.offAll(HomeView());
    } else {
      alertError(context, "Gagal menghapus data !");
    }
  }

  void tapUpdateProduct(
      int id, String name, String code, String poto, String harga) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("idProd", id);
    prefs.setString("codeProd", code);
    prefs.setString("namaProd", name);
    prefs.setString("hargaProd", harga);
    prefs.setString("fotoProd", poto);
    Get.offAll(UpdateProductView());
  }
}
