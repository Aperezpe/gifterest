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
    @required this.onTap,
  }) : super(key: key);

  final ProductsGridModel model;
  final VoidCallback onTap;

  static Widget create({
    @required Friend friend,
    @required FirestoreDatabase database,
    @required EventType eventType,
    @required onTap,
  }) {
    return ChangeNotifierProvider<ProductsGridModel>(
      create: (context) => ProductsGridModel(
        friend: friend,
        database: database,
        eventType: eventType,
      ),
      child: Consumer<ProductsGridModel>(
        builder: (_, model, __) => ProductsGridView(model: model, onTap: onTap),
      ),
    );
  }

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView>
    with AutomaticKeepAliveClientMixin<ProductsGridView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Product>>(
      stream: widget.model.queryProductsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.hasData) {
          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .9,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return ClickableProduct(
                onTap: widget.onTap,
                product: snapshot.data[index],
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
