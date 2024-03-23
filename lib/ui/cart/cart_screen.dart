import 'package:flutter/material.dart';
import 'package:myshop/ui/orders/order_manager.dart';
import 'package:provider/provider.dart';

import 'cart_manager.dart';
import 'cart_item_cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          cartSummary(
            cart: cart,
            onOrderNowPressed: cart.totalAmount <= 0
              ? null
              : () {
                context.read<OrderManager>().addOrder(
                  cart.products,
                  cart.totalAmount,
                  );
                cart.clearAllItems();
              },
             
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CartItemList(cart),
          )
        ],
      ),
    );
  }
}

class CartItemList extends StatelessWidget{
  const CartItemList(
    this.cart, {
      super.key,
  });

  final CartManager cart;

  @override
  Widget build(BuildContext context){
    return ListView(
      children: cart.productEntries
      .map(
        (entry) => CartItemCard(
          productId: entry.key, 
          cartItem: entry.value,
          ),
      )
      .toList(),
    );
  }
}

class cartSummary extends StatelessWidget{
  const cartSummary({
    super.key,
    required this.cart,
    this.onOrderNowPressed,
    });

    final CartManager cart;
    final void Function()? onOrderNowPressed;

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
              Chip(
                label: Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: onOrderNowPressed,
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: const Text('ORDER NOW'),
                )
            
          ],
        ),
        ),
    );
  }
}