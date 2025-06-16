import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = context.watch<CartModel>();
    final userModel = context.watch<UserModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: Text(
              "${cartModel.products.length} ${cartModel.products.length == 1 ? "ITEM" : "ITENS"}",
              style: const TextStyle(fontSize: 17.0),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (_) {
          if (cartModel.isLoading && userModel.isLoggedIn()) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!userModel.isLoggedIn()) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                      size: 80.0, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Faça o login para adicionar produtos!",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Entrar", style: TextStyle(fontSize: 18.0)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  )
                ],
              ),
            );
          } else if (cartModel.products.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children:
                  cartModel.products.map((p) => CartTile(p)).toList(),
                ),
                const DiscountCard(),
                const ShipCard(),
                CartPrice(() async {
                  final orderId = await cartModel.finishOrder();
                  if (orderId != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId),
                      ),
                    );
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
