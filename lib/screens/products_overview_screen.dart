import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});
  static const routeName = '/';

  @override
  ProductOverviewScreenState createState() => ProductOverviewScreenState();
}

class ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = true;

  @override
  void initState() {
    //TODO: pub dev explains how to work in this situation
    super.initState();
    context.read<ProductsRepository>().fetchAndSetProducts().then((_) => setState(() {
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    //   final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show All'),
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                value: cart.itemCount.toString(),
                child: ch!,
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : ProductsGrid(_showOnlyFavorites));
  }
}
