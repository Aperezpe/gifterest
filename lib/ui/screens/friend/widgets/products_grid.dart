import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/friend/models/products_grid_model.dart';
import 'package:bonobo/ui/screens/friend/widgets/clickable_product.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGridView extends StatefulWidget {
  const ProductsGridView({
    Key key,
    @required this.model,
    @required this.onEndValues,
  }) : super(key: key);

  final ProductsGridModel model;
  final RangeValues onEndValues;

  static Widget create({
    @required Friend friend,
    @required FirestoreDatabase database,
    @required EventType eventType,
    @required RangeValues onEndValues,
  }) {
    return ChangeNotifierProvider<ProductsGridModel>(
      create: (context) => ProductsGridModel(
        friend: friend,
        database: database,
        eventType: eventType,
      ),
      child: Consumer<ProductsGridModel>(
        builder: (_, model, __) => ProductsGridView(
          model: model,
          onEndValues: onEndValues,
        ),
      ),
    );
  }

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView>
    with AutomaticKeepAliveClientMixin<ProductsGridView> {
  @override
  bool get wantKeepAlive => true;

  int get startValue => widget.onEndValues.start.round();
  int get endValue => widget.onEndValues.end.round();

  List<Product> queryProducts(List<Product> products) {
    products = products
        .where((product) {
          if (endValue >= 100) return product.price >= startValue;
          return product.price >= startValue && product.price <= endValue;
        })
        .where((product) =>
            (product.gender == widget.model.friend.gender) ||
            (product.gender == ""))
        .toList();

    return products;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Product>>(
      stream: widget.model.queryProductsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.hasData) {
          List<Product> products = queryProducts(snapshot.data);

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
                key: Key("product-box-${products[index].id}"),
                database: widget.model.database,
                product: products[index],
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
