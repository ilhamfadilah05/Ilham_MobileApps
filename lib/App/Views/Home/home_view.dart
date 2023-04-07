// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/App/Components/Currency/currency_format.dart';
import 'package:point_of_sales/App/Components/Widget/Container/container.dart';
import 'package:point_of_sales/App/Components/Widget/Text/text_stye.dart';
import 'package:point_of_sales/App/Models/Home/product_model.dart';
import 'package:point_of_sales/App/Services/Home/home_service.dart';
import 'package:point_of_sales/App/Views/Home/add_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/Home/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final conn = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textDefault(
                      conn.title.value, Colors.black, 18, FontWeight.bold),
                  InkWell(
                    onTap: () => Get.offAll(AddProductView()),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              )),
          body: containerDefault(context, body(context)),
        ));
  }

  Widget body(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.3;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey[700],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextFormField(
                        style: TextStyle(fontFamily: 'poppins'),
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari menu..."),
                      ))
                    ],
                  ),
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
                FutureBuilder<List<ProductModel>>(
                    future: getProductAll(),
                    builder: (context, snapshot) {
                      List<ProductModel>? data = snapshot.data;
                      if (snapshot.hasData) {
                        return GridView.builder(
                          padding: EdgeInsets.only(bottom: 20),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: data!.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () => conn.dialogDeleteProduct(
                                  context, "${data[index].id}"),
                              onTap: () async {
                                conn.tapUpdateProduct(
                                    data[index].id!,
                                    data[index].name!,
                                    data[index].foodCode!,
                                    data[index].picture!,
                                    data[index].harga!);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 2)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 120,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Image.network(
                                            data[index].picture!,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          textDefault(
                                              data[index].name!,
                                              Colors.black,
                                              14,
                                              FontWeight.bold),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              textDefault(
                                                  "Rp. " +
                                                      CurrencyFormat
                                                          .convertToIdr(
                                                              int.parse(
                                                                  data[index]
                                                                      .harga!),
                                                              0),
                                                  Colors.blue[800]!,
                                                  14,
                                                  FontWeight.bold),
                                              textDefault('/porsi', Colors.grey,
                                                  12, FontWeight.normal)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        conn.tapOrder(
                                            data[index].id!,
                                            data[index].foodCode!,
                                            data[index].name!,
                                            data[index].picture!,
                                            data[index].createAt!,
                                            data[index].harga!,
                                            1);
                                        print(conn.cartList);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                            color: Colors.blue[800],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: textDefault(
                                                "Order",
                                                Colors.white,
                                                14,
                                                FontWeight.normal)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return PlayStoreShimmer();
                      }
                      return PlayStoreShimmer();
                    }),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.blue[800],
                )),
                InkWell(
                  onTap: () {
                    conn.bottomSheet();
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.arrow_drop_up_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.blue[800],
                )),
              ],
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
                              child: textDefault("${conn.cartList.length}",
                                  Colors.white, 12, FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      textDefault(
                          "Rp. ${CurrencyFormat.convertToIdr(conn.hargaTotal.value, 0)}",
                          Colors.black,
                          16,
                          FontWeight.bold)
                    ],
                  ),
                  InkWell(
                    onTap: () => conn.dialogPembayaran(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: textDefault(
                          "Charge", Colors.white, 14, FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
