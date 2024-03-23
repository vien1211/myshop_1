// import 'package:flutter/material.dart';

// import 'ui/products/products_manager.dart';

// import 'ui/products/products_detail_screen.dart';

// import 'ui/products/products_overview_screen.dart';

// import 'ui/products/user_products_screen.dart';

// import 'ui/cart/cart_screen.dart';

// import 'ui/orders/orders_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myshop/models/product.dart';

import 'ui/screen.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.purple,
      secondary: Colors.deepOrange,
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themeData = ThemeData(
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderManager(),
        ),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: colorScheme,
              appBarTheme: AppBarTheme(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 4,
                shadowColor: colorScheme.shadow,
              ),
            ),
            home: authManager.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    }),
            routes: {
              CartScreen.routeName: (ctx) => const SafeArea(
                    child: CartScreen(),
                  ),
              OrderScreen.routeName: (ctx) => const SafeArea(
                    child: OrderScreen(),
                  ),
              UserProductsScreen.routeName: (ctx) => const SafeArea(
                    child: UserProductsScreen(),
                  ),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: ProductDetailScreen(
                          ctx.read<ProductsManager>().findById(productId)!),
                    );
                  },
                );
              }

              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      ),
                    );
                  },
                );
              }
            });
      }),
    );
  }
}
