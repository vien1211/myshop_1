import 'package:flutter/material.dart';
import 'package:myshop/models/cart_item.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = 'product-detail';
  final Product product;

  const ProductDetailScreen(
    this.product, {
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.product.isFavorite = !widget.product.isFavorite;
              });
            },
            icon: Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.product.isFavorite ? Colors.red : null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Số lượng: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 103, 93, 93),
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Xử lý thêm vào giỏ hàng
                          final cart = context.read<CartManager>();
                          cart.addItem(widget.product, quantity); // Passing the product and quantity
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added item to cart'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color.fromARGB(255, 194, 58, 239),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons
                                .shopping_cart), // Thêm biểu tượng giỏ hàng
                            SizedBox(
                                width:4), // Tạo một khoảng cách nhỏ giữa biểu tượng và văn bản
                            Text('Thêm vào giỏ hàng',
                                style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
