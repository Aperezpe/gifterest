import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/favorite_button.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final bool isFavorite;

  ProductPage({
    Key key,
    this.product,
    this.isFavorite,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isFavoriteResponse;

  @override
  void initState() {
    super.initState();
    _isFavoriteResponse = widget.isFavorite;
  }

  _launchURL() async {
    String url = widget.product.itemUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _toggleFavorite(BuildContext context, bool _isFavorite) async {
    final database = Provider.of<Database>(context, listen: false);
    _isFavoriteResponse = _isFavorite;

    if (_isFavorite) {
      await database.setFavorite(widget.product);
    } else {
      await database.deleteFavorite(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context, _isFavoriteResponse),
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
                        valueChanged: (_isFavorite) =>
                            _toggleFavorite(context, _isFavorite),
                        isFavorite: widget.isFavorite,
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
