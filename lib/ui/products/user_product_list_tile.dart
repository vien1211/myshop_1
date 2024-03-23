import "package:flutter/material.dart";
import 'package:myshop/ui/products/products_manager.dart';
import 'package:myshop/ui/screen.dart';

import '../../models/product.dart';
import 'package:provider/provider.dart';

class UserProductListTile extends StatelessWidget{
  final Product product;

  const UserProductListTile(
    this.product, {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              EditUserProductButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: product.id,
                  );
                },
              ),
              DeleteUserProductButton(
                onPressed: (){
                  context.read<ProductsManager>().deleteProduct(product.id!);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Product deleted',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
    );
  }
}

class DeleteUserProductButton extends StatelessWidget{
  const DeleteUserProductButton({super.key, this.onPressed, });

  final void Function()? onPressed;

  @override
  Widget build (BuildContext context) {
    return IconButton(
      onPressed: onPressed, 
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
      );

  }
}

class EditUserProductButton extends StatelessWidget{
  const EditUserProductButton({super.key, this.onPressed,});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
    );

  }
}