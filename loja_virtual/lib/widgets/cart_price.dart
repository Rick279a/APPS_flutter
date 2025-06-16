import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  const CartPrice(this.buy, {super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CartModel>();

    double price = model.getProductsPrice();
    double discount = model.getDiscount();
    double ship = model.getShipPrice();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Resumo do Pedido",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Subtotal"),
                Text("R\$ ${price.toStringAsFixed(2)}")
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Desconto"),
                Text("R\$ ${discount.toStringAsFixed(2)}")
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Entrega"),
                Text("R\$ ${ship.toStringAsFixed(2)}")
              ],
            ),
            const Divider(),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: buy,
              child: const Text("Finalizar Pedido"),
            )
          ],
        ),
      ),
    );
  }
}
