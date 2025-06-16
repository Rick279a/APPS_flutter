import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final tiles = snapshot.data!.docs.map((doc) {
            return CategoryTile(doc);
          }).toList();

          final dividedTiles = ListTile.divideTiles(
            tiles: tiles,
            color: Colors.grey[500],
          ).toList();

          return ListView(children: dividedTiles);
        }
      },
    );
  }
}
