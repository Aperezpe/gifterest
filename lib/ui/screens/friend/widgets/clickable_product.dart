import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/friend/widgets/product_page.dart';
import 'package:flutter/material.dart';

class ClickableProduct extends StatefulWidget {
  ClickableProduct({
    @required this.product,
  });

  final Product product;

  @override
  _ClickableProductState createState() => _ClickableProductState();
}

class _ClickableProductState extends State<ClickableProduct> {
  bool showProductDetails = false;

  void _showProductDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => ProductPage(product: widget.product),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showProductDetails,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
