import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/clickable_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatefulWidget {
  const ProductsGridView({
    Key key,
    @required this.sliderValues,
    @required this.productStream,
    @required this.gender,
    @required this.database,
  }) : super(key: key);

  final RangeValues sliderValues;
  final Stream<List<Product>> productStream;
  final String gender;
  final FirestoreDatabase database;

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView>
    with AutomaticKeepAliveClientMixin<ProductsGridView> {
  @override
  bool get wantKeepAlive => true;

  int get startValue => widget.sliderValues.start.round();
  int get endValue => widget.sliderValues.end.round();

  List<Product> queryProducts(List<Product> products) {
    products = products
        .where((product) {
          if (endValue >= 100) return product.price >= startValue;
          return product.price >= startValue && product.price <= endValue;
        })
        .where((product) =>
            (product.gender == widget.gender) || (product.gender == ""))
        .toList();

    return products;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Product>>(
      stream: widget.productStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.hasData) {
          final products = queryProducts(snapshot.data);

          return StreamBuilder<List<Product>>(
            stream: widget.database.favoritesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final favorites = snapshot.data;

                return GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return ClickableProduct(
                      favorites: favorites,
                      key: Key("product-box-${products[index].id}"),
                      product: products[index],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                Center(child: Text(snapshot.error.toString()));
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
