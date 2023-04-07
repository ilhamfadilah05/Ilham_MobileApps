import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/App/Components/Widget/Container/container.dart';
import 'package:point_of_sales/App/Components/Widget/Text/text_stye.dart';
import 'package:point_of_sales/App/Controllers/Splashscreen/splahscreen_controller.dart';

class SplashscreenView extends StatelessWidget {
  SplashscreenView({super.key});
  final conn = Get.put(SplashscreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => containerDefault(context, body())),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(),
        Image.asset(
          'assets/images/logo_pos.png',
          width: 150,
        ),
        const SizedBox(
          height: 20,
        ),
        textDefault(conn.name.value, Colors.black, 24, FontWeight.bold),
      ],
    );
  }
}
