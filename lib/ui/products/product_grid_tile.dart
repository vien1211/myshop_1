import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:provider/provider.dart';


import '../../models/product.dart';

import 'products_detail_screen.dart';

class ProductGridTile extends StatelessWidget{
  const ProductGridTile(
    this.product, {
      super.key,
    });

    final Product product;

    @override
    Widget build (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: ProductGridFooter(
            product : product,
            onFavoritePressed: (){
              product.isFavorite = !product.isFavorite;
            },
            onAddToCartPressed: () {
              final cart = context.read<CartManager>();
              cart.addItem(product, 1);

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Item added to cart',
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed:(){
                        cart.removeItem(product.id!);
                      },
                      ),
                    ),
                );
            },
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
                
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
}

class ProductGridFooter extends StatelessWidget{
  const ProductGridFooter({ 
    super.key,
    required this.product,
    this.onFavoritePressed,
    this.onAddToCartPressed,
    });

    final Product product;
    final void Function()? onFavoritePressed;
    final void Function()? onAddToCartPressed;

  @override
  Widget build(BuildContext context){
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: ValueListenableBuilder<bool>(
        valueListenable: product.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onFavoritePressed,
          );
        },
      ),
      title: Text(
        product.title,
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.shopping_cart,
        ),
        onPressed: onAddToCartPressed,
        color: Theme.of(context).colorScheme.secondary,
      ),


      
      // leading: IconButton(
      //   icon: Icon(
      //     product.isFavorite ? Icons.favorite : Icons.favorite_border,
      //   ),
      //   color: Theme.of(context).colorScheme.secondary,
      //   onPressed: onFavoritePressed,
      // ),
      // title:  Text(
      //   product.title,
      //   textAlign: TextAlign.center,
      // ),
      // trailing: IconButton(
      //   icon: const Icon(
      //     Icons.shopping_cart,
      //   ),
      //   onPressed: onAddToCartPressed,
      //   color: Theme.of(context).colorScheme.secondary,
      // ),

    );

  }
}