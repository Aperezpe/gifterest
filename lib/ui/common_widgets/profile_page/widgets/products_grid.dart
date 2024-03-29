import 'package:flutter/foundation.dart';
import 'package:gifterest/resize/size_config.dart';
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
    @required this.favoritesStream,
    @required this.gender,
    @required this.person,
    @required this.database,
    this.eventType,
  }) : super(key: key);

  final RangeValues sliderValues;
  final Stream<List<Product>> productStream;
  final Stream<List<Product>> favoritesStream;
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

  List<Product> shuffledProducts = [];

  // Filters products depending on price and geneder
  List<Product> queryProducts(List<Product> products) {
    // Exclude anniversary and valenties from querying gender since this is done in query Strem level
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

  // Toggles favorite at friend/user profile page level
  void _toggleFavorite(bool isFavorite, Product product) async {
    final database = Provider.of<Database>(context, listen: false);

    if (isFavorite) {
      _isUser
          ? await database.setFavorite(product)
          : await database.setFriendFavorite(
              widget.person, widget.eventType, product);
    } else {
      _isUser
          ? await database.deleteFavorite(product)
          : await database.deleteFriendFavorite(
              widget.person, widget.eventType, product);
    }
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
          List<Product> products = snapshot.data;

          if (shuffledProducts.isEmpty) {
            snapshot.data.shuffle();
            products = shuffledProducts = queryProducts(snapshot.data);
          } else {
            products = queryProducts(shuffledProducts);
          }

          if (products.isEmpty)
            return EmptyContent(
              title: "There's nothing here!",
              message: "No products to show in this filter",
            );

          return StreamBuilder<List<Product>>(
            stream: widget.favoritesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final favorites = queryProducts(snapshot.data);

                // To show favorites at the top of each category
                favorites.forEach((favorite) => products.remove(favorite));
                products.insertAll(0, favorites);

                print("Toggling favorites in ${widget.eventType}");

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
                      isUser: _isUser,
                      isFavorite: favorites.contains(products[index]),
                      valueChanged: (isFavorite) => _toggleFavorite(
                        isFavorite,
                        products[index],
                      ),
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
