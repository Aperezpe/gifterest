import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/common_widgets/favorite_button.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/common_widgets/product_page.dart';
import 'package:bonobo/ui/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClickableProduct extends StatefulWidget {
  ClickableProduct({
    @required this.key,
    @required this.product,
    @required this.favorites,
  }) : super(key: key);

  final Key key;
  final Product product;
  final List<Product> favorites;

  @override
  _ClickableProductState createState() => _ClickableProductState();
}

class _ClickableProductState extends State<ClickableProduct> {
  bool showProductDetails = false;

  List<Product> get favorites => widget.favorites;
  final favoritesController = locator.get<FavoritesController>();
  bool get isFavorite => favoritesController.isFavorite[widget.product.id];

  @override
  void initState() {
    super.initState();

    if (favorites.contains(widget.product)) {
      favoritesController.isFavorite[widget.product.id] = true;
    } else {
      favoritesController.isFavorite[widget.product.id] = false;
    }
  }

  void _showProductDetails() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductPage(
          product: widget.product,
          onChanged: _toggleFavorite,
        ),
      ),
    );
  }

  void _toggleFavorite(bool isFavorite) async {
    final database = Provider.of<Database>(context, listen: false);
    favoritesController.isFavorite[widget.product.id] =
        !favoritesController.isFavorite[widget.product.id];

    if (isFavorite) {
      await database.setFavorite(widget.product);
    } else {
      await database.deleteFavorite(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showProductDetails,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 15, 5),
                  child: Column(
                    children: [
                      Text(
                        widget.product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        "\$${widget.product.price}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 12, right: 12),
            child: FavoriteButton(
              valueChanged: _toggleFavorite,
              iconSize: 45,
              isFavorite: isFavorite,
              iconColor: isFavorite ? Colors.red : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
