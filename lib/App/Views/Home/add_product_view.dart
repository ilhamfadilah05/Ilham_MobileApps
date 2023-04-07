// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/App/Components/Widget/Container/container.dart';
import 'package:point_of_sales/App/Controllers/Home/add_product_controller.dart';
import 'package:point_of_sales/App/Views/Home/home_view.dart';

import '../../Components/Widget/Text/text_stye.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});
  final conn = Get.put(AddProductController());

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
          Row(
            children: [
              textDefault("Kode Produk :", Colors.black, 16, FontWeight.normal),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextFormField(
                enabled: false,
                controller: conn.codeProd,
                style: TextStyle(fontFamily: 'poppins', fontSize: 16),
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              textDefault("Nama Produk :", Colors.black, 16, FontWeight.normal),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: conn.namaProd,
                style: TextStyle(fontFamily: 'poppins', fontSize: 16),
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              textDefault(
                  "Harga Produk : Rp. ", Colors.black, 16, FontWeight.normal),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: conn.hargaProd,
                keyboardType: TextInputType.number,
                style: TextStyle(fontFamily: 'poppins', fontSize: 16),
              ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          (conn.foto.value == "")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        conn.foto.value,
                        fit: BoxFit.cover,
                      ))),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              textDefault("Foto Produk :", Colors.black, 16, FontWeight.normal),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: conn.fotoProd,
                onChanged: (value) {
                  conn.cekFoto(value);
                },
                style: TextStyle(fontFamily: 'poppins', fontSize: 16),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "*Foto produk harap masukkan link gambar",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'poppins',
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              conn.validasi(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: conn.isLoading.value
                  ? Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : textDefault(
                      "Simpan Produk", Colors.white, 14, FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
