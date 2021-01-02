import 'package:bonobo/ui/models/product.dart';
import 'package:flutter/material.dart';

class ClickableProduct extends StatelessWidget {
  ClickableProduct({
    @required this.product,
    @required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      product.distributor,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "\$${product.price}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
