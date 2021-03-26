import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/empty_widgets.dart';
import 'package:bonobo/ui/screens/favorites.dart';
import 'package:bonobo/ui/screens/friend/widgets/clickable_product.dart';
import 'package:bonobo/ui/screens/locator.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key key, this.database}) : super(key: key);

  final Database database;
  final favorites = locator.get<Favorites>().favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: favorites.isEmpty
          ? Container(child: Center(child: EmptyWidget()))
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: favorites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .9,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                return ClickableProduct(
                  key: Key("product-box-${favorites[index].id}"),
                  database: database,
                  product: favorites[index],
                );
              },
            ),
    );
  }
}
