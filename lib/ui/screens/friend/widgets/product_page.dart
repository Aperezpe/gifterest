import 'package:bonobo/ui/models/product.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({
    Key key,
    this.product,
  }) : super(key: key);

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
                    Container(
                      padding: EdgeInsets.all(8),
                      child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.grey[300],
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  product.distributor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "${product.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Check Out on Amazon",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
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
