import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/favorite_button.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({
    Key key,
    this.product,
  }) : super(key: key);

  _launchURL() async {
    String url = product.itemUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
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
                        child: Image.network(product.imageUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15, right: 15),
                      child: FavoriteButton(
                        valueChanged: (_isFavorite) =>
                            print("Is Favorite? $_isFavorite"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "\$${product.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  product.distributor,
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
