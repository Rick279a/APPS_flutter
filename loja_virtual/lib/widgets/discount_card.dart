import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:provider/provider.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = context.watch<CartModel>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: cartModel.couponCode ?? "",
              onFieldSubmitted: (text) async {
                final docSnap = await FirebaseFirestore.instance
                    .collection("coupons")
                    .doc(text)
                    .get();

                if (docSnap.exists) {
                  cartModel.setCoupon(text, docSnap.data()!["percent"]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Desconto de ${docSnap.data()!["percent"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  cartModel.setCoupon("", 0);  // Alterado para string vazia
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cupom não existente!"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
