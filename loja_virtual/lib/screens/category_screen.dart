import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  const CategoryScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data()?["title"] ?? "Categoria"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(snapshot.id)
              .collection("items")
              .get(),
          builder: (context, snapshotQuery) {
            if (snapshotQuery.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshotQuery.hasError) {
              return const Center(child: Text("Erro ao carregar os produtos."));
            }

            if (!snapshotQuery.hasData) {
              return const Center(child: Text("Nenhum produto encontrado."));
            }

            // Filtra produtos válidos: com título e preço
            final docs = snapshotQuery.data!.docs.where((doc) {
              final data = doc.data();
              return data["title"] != null &&
                  data["title"].toString().trim().isNotEmpty &&
                  data["price"] != null;
            }).toList();

            if (docs.isEmpty) {
              return const Center(child: Text("Nenhum produto a ser exibido."));
            }

            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(4.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final product = ProductData.fromDocument(docs[index]);
                    product.category = snapshot.id;
                    return ProductTile("grid", product);
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(4.0),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final product = ProductData.fromDocument(docs[index]);
                    product.category = snapshot.id;
                    return ProductTile("list", product);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
