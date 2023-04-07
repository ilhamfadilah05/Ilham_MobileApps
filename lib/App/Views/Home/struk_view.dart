// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/App/Components/Widget/Container/container.dart';
import 'package:point_of_sales/App/Controllers/Home/struk_controller.dart';
import 'package:point_of_sales/App/Views/Home/home_view.dart';

import '../../Components/Currency/currency_format.dart';
import '../../Components/Widget/Text/text_stye.dart';

class StrukView extends StatelessWidget {
  StrukView({super.key});
  final conn = Get.put(StrukController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            Get.offAll(HomeView());
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDefault("${conn.title.value}", Colors.black, 18,
                        FontWeight.bold),
                    InkWell(
                      onTap: () => Get.offAll(HomeView()),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(10)),
                        child: textDefault(
                            "Selesai", Colors.white, 14, FontWeight.normal),
                      ),
                    )
                  ],
                )),
            body: containerDefault(context, body(context)),
          ),
        ));
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textDefault(
                        "Warung Ilham", Colors.black, 25, FontWeight.bold)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Jl. Abdul Wahab, Sawangan Depok",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "0858-9085-0187 / ilhamalmamur@gmail.com",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 10,
                      ),
                    )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDefault(
                        "No. Invoice", Colors.black, 14, FontWeight.normal),
                    textDefault("${conn.noInvoice.value}", Colors.black, 14,
                        FontWeight.normal)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 0,
                ),
                ListView.builder(
                    itemCount: conn.cartList.length,
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      var data = conn.cartList[i];
                      return Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textDefault((data['name']), Colors.black,
                                        14, FontWeight.normal),
                                    Row(
                                      children: [
                                        textDefault(
                                            ("Rp. " +
                                                "${CurrencyFormat.convertToIdr(int.parse(data['price']), 0)}"),
                                            Colors.black,
                                            14,
                                            FontWeight.normal),
                                        textDefault("(X" + "${data['qty']})",
                                            Colors.black, 14, FontWeight.normal)
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            textDefault(
                                "Rp. ${CurrencyFormat.convertToIdr(int.parse(data['price']) * data['qty'], 0)}",
                                Colors.black,
                                15,
                                FontWeight.bold)
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDefault(
                        "Total Harga", Colors.black, 14, FontWeight.normal),
                    textDefault(
                        "Rp. ${CurrencyFormat.convertToIdr(int.parse(conn.totalBayar.value), 0)}",
                        Colors.black,
                        16,
                        FontWeight.bold)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDefault(
                        "Uang Di Bayar", Colors.black, 14, FontWeight.normal),
                    textDefault(
                        "Rp. ${CurrencyFormat.convertToIdr(int.parse(conn.uangDibayar.value), 0)}",
                        Colors.black,
                        16,
                        FontWeight.bold)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDefault(
                        "Total Kembalian", Colors.black, 14, FontWeight.normal),
                    textDefault(
                        "Rp. ${CurrencyFormat.convertToIdr(int.parse(conn.uangKembalian.value), 0)}",
                        Colors.black,
                        16,
                        FontWeight.bold)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textDefault("Terimakasih telah berbelanja di toko kami.",
                        Colors.black, 14, FontWeight.normal)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
