import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/common_widgets/empty_content.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/models/product.dart';
import 'package:gifterest/ui/common_widgets/profile_page/widgets/clickable_product.dart';
import 'package:gifterest/ui/screens/friend/event_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGridView extends StatefulWidget {
  const ProductsGridView({
    Key key,
    @required this.sliderValues,
    @required this.productStream,
    @required this.gender,
    @required this.person,
    @required this.database,
    this.eventType,
  }) : super(key: key);

  final RangeValues sliderValues;
  final Stream<List<Product>> productStream;
  final String gender;
  final Person person;
  final FirestoreDatabase database;
  final EventType eventType;

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView>
    with AutomaticKeepAliveClientMixin<ProductsGridView> {
  @override
  bool get wantKeepAlive => true;

  int get startValue => widget.sliderValues.start.round();
  int get endValue => widget.sliderValues.end.round();
  bool get _isUser => widget.person.id == widget.database.uid;

  List<Product> queryProducts(List<Product> products) {
    if (widget.eventType != EventType.anniversary)
      products = products
          .where((product) {
            if (endValue >= 100) return product.price >= startValue;
            return product.price >= startValue && product.price <= endValue;
          })
          .where((product) =>
              (product.gender == widget.gender) || (product.gender == ""))
          .toList();
    else
      products = products.where((product) {
        if (endValue >= 100) return product.price >= startValue;
        return product.price >= startValue && product.price <= endValue;
      }).toList();

    return products;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return StreamBuilder<List<Product>>(
      stream: widget.productStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.hasData) {
          final products = queryProducts(snapshot.data);
          products.shuffle();

          if (products.isEmpty)
            return EmptyContent(
              title: "There's nothing here!",
              message: "No products to show in this range",
            );

          return StreamBuilder<List<Product>>(
            stream: _isUser
                ? widget.database.favoritesStream()
                : widget.database.friendFavoritesStream(widget.person),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final favorites = snapshot.data;

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    SizeConfig.safeBlockHorizontal * 2,
                    SizeConfig.safeBlockVertical,
                    SizeConfig.safeBlockHorizontal * 2,
                    SizeConfig.safeBlockVertical * 5,
                  ),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: is700Wide ? 3 : 2,
                    childAspectRatio: .9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return ClickableProduct(
                      favorites: favorites,
                      key: Key("product-box-${products[index].id}"),
                      product: products[index],
                      person: widget.person,
                      isUser: _isUser,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                Center(child: Text(snapshot.error.toString()));
              }
              return LoadingScreen();
            },
          );
        }
        return LoadingScreen();
      },
    );
  }
}
