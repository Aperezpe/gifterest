import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/favorite_button.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final ValueChanged<bool> onChanged;

  ProductPage({
    Key key,
    this.product,
    this.onChanged,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final favoritesController = locator.get<FavoritesController>();
  bool get isFavorite => favoritesController.isFavorite[widget.product.id];

  @override
  void initState() {
    super.initState();
  }

  _launchURL() async {
    String url = widget.product.itemUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(widget.product.name),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Center(
                      child: Container(
                        child: Image.network(widget.product.imageUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15, right: 15),
                      child: FavoriteButton(
                        valueChanged: _toggleFavorite,
                        iconColor: isFavorite ? Colors.red : Colors.grey[300],
                        isFavorite: isFavorite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "\$${widget.product.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  widget.product.distributor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: 'Check out in store',
                  color: Colors.orange,
                  onPressed: _launchURL,
                ),
                Divider(thickness: 1, color: Colors.grey[400], height: 35),
                Container(
                  child: Text(
                    "Product Rating",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildRating(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, color: Colors.grey[400]),
        Icon(Icons.star, color: Colors.grey[400]),
        Icon(Icons.star, color: Colors.grey[400]),
        Icon(Icons.star, color: Colors.grey[400]),
        Icon(Icons.star, color: Colors.grey[400]),
      ],
    );
  }
}
