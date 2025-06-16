import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category;
  late String id;

  late String title;
  late String description;
  late double price;

  late List<dynamic> images;
  late List<dynamic> sizes;

  ProductData.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    id = snapshot.id;
    final data = snapshot.data() ?? {};
    title = data["title"] ?? "Produto sem título";
    description = data["description"] ?? "";
    price = (data["price"] ?? 0).toDouble();
    images = data["images"] ?? [];
    sizes = data["sizes"] ?? [];
  }

  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
