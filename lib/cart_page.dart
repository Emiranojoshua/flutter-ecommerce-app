import 'package:ecommerce_app/global_variables.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (BuildContext context, int index) {
          final cartItem = cart[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                cartItem['imageUrl'] as String,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
            title: Text(
              cartItem['title'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text("Size: ${cartItem['prize']}"),
          );
        },
      ),
    );
  }
}
