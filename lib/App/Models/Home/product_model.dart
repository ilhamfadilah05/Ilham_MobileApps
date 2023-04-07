class ProductModel {
  int? id;
  String? foodCode;
  String? name;
  String? picture;
  String? pictureOri;
  String? harga;

  String? createAt;

  ProductModel({
    this.id,
    this.foodCode,
    this.name,
    this.picture,
    this.pictureOri,
    this.harga,
    this.createAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> js) {
    return ProductModel(
      id: js['id'],
      foodCode: js['food_code'],
      name: js['name'],
      picture: js['picture'],
      pictureOri: js['picture_ori'],
      harga: js['price'],
      createAt: js['created_at'],
    );
  }
}
