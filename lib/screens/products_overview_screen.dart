import 'package:flutter/material.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ProductsGrid(_showOnlyFavorites)),
    );
  }
}
