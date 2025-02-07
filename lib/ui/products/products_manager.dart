import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../models/auth_token.dart';
import '../../services/products_service.dart';

class ProductsManager with ChangeNotifier {
  List<Product> _items = [];

  final ProductsService _productsService;
  
  ProductsManager([AuthToken? authToken])
    : _productsService = ProductsService(authToken);

    set authToken(AuthToken? authToken){
    _productsService.authToken = authToken;
  }

  Future<void> fetchProducts() async {
    _items = await _productsService.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchUsersProducts() async {
    _items = await _productsService.fetchProducts(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);

    if(newProduct != null){
      _items.add(newProduct);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id){
    try{
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> updateProduct(Product product) async{
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if(await _productsService.updateProduct(product)){
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  void toggleFavoriteStatus(Product product){
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Product? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if(!await _productsService.deleteProduct(id)){
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  
  }

  
}