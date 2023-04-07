import 'dart:convert';

import 'package:point_of_sales/App/Models/Home/product_model.dart';
import 'package:http/http.dart' as http;

Future<List<ProductModel>> getProductAll() async {
  var request = http.Request('GET',
      Uri.parse("https://apigenerator.dronahq.com/api/g7s7P925/TestAlan/"));

  http.StreamedResponse response = await request.send();
  var responseString = await response.stream.bytesToString();
  final dataa = json.decode(responseString);
  if (response.statusCode == 200) {
    return List<ProductModel>.from(
        (dataa as List).map((e) => ProductModel.fromJson(e)));
  } else {
    print(response.reasonPhrase);
  }

  return dataa.map((data) => ProductModel.fromJson(data)).toList();
}
