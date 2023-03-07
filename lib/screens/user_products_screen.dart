import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsRepository>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsRepository>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[IconButton(onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName), icon: const Icon(Icons.add))],
        ),
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                      children: <Widget>[
                        UserProductItem(productsData.items[i].id, productsData.items[i].title, productsData.items[i].imageUrl),
                        const Divider(),
                      ],
                    )),
          ),
        ));
  }
}
