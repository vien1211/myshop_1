import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_manager.dart';
import 'order_item_card.dart';

import '../shared/app_drawer.dart';

class OrderScreen extends StatelessWidget{
  static const routeName = '/orders';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        ),
      drawer: const AppDrawer(),
      body: Consumer<OrderManager>(
        builder: (ctx, orderManager, child) {
          return ListView.builder(
            itemCount: orderManager.orderCount,
            itemBuilder: (ctx, i) => OrderItemCard(orderManager.orders[i]),
            );
        },
        
      ),
    );
  }
}