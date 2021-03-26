import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/favorite_button.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/favorites.dart';
import 'package:bonobo/ui/screens/friend/widgets/product_page.dart';
import 'package:bonobo/ui/screens/locator.dart';
import 'package:flutter/material.dart';

class ClickableProduct extends StatefulWidget {
  ClickableProduct({
    @required this.key,
    @required this.product,
    @required this.database,
  }) : super(key: key);

  final Key key;
  final Product product;
  final Database database;

  @override
  _ClickableProductState createState() => _ClickableProductState();
}

class _ClickableProductState extends State<ClickableProduct> {
  bool showProductDetails = false;
  bool _isFavorite = false;
  final favorites = locator.get<Favorites>().favorites;

  @override
  void initState() {
    super.initState();

    if (favorites.contains(widget.product)) {
      _isFavorite = true;
    }
  }

  void _showProductDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => ProductPage(product: widget.product),
    ));
  }

  void _toggleFavorite(bool isFavorite) async {
    _isFavorite = isFavorite;

    if (_isFavorite) {
      await widget.database.setFavorite(widget.product);
    } else {
      await widget.database.deleteFavorite(widget.product);
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
              valueChanged: (value) => _toggleFavorite(value),
              iconSize: 45,
              isFavorite: _isFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
