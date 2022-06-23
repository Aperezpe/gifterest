import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/favorite_button.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/models/product.dart';
import 'package:gifterest/ui/common_widgets/profile_page/product_page.dart';
import 'package:gifterest/ui/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClickableProduct extends StatefulWidget {
  ClickableProduct({
    @required this.key,
    @required this.product,
    @required this.favorites,
    @required this.person,
    this.isUser: true,
  }) : super(key: key);

  final Key key;
  final Product product;
  final List<Product> favorites;
  final Person person;
  final bool isUser;

  @override
  _ClickableProductState createState() => _ClickableProductState();
}

class _ClickableProductState extends State<ClickableProduct> {
  bool showProductDetails = false;

  List<Product> get favorites => widget.favorites;
  final favoritesController = locator.get<FavoritesController>();
  bool get isFavorite => favoritesController.isFavorite[widget.product.id];

  @override
  void initState() {
    super.initState();

    if (favorites.contains(widget.product)) {
      favoritesController.isFavorite[widget.product.id] = true;
    } else {
      favoritesController.isFavorite[widget.product.id] = false;
    }
  }

  void _showProductDetails() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductPage(
          product: widget.product,
          onChanged: _toggleFavorite,
        ),
      ),
    );
  }

  // Toggles favorite at friend/user profile page level
  void _toggleFavorite(bool isFavorite) async {
    final database = Provider.of<Database>(context, listen: false);
    favoritesController.isFavorite[widget.product.id] =
        !favoritesController.isFavorite[widget.product.id];

    if (isFavorite) {
      await widget.isUser
          ? database.setFavorite(widget.product)
          : database.setFriendFavorite(widget.person, widget.product);
    } else {
      await widget.isUser
          ? database.deleteFavorite(widget.product)
          : database.deleteFriendFavorite(widget.person, widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final is700Wide = SizeConfig.screenWidth >= 700;

    return GestureDetector(
      onTap: _showProductDetails,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: SizeConfig.blockSizeHorizontal,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeVertical * 2),
            ),
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
                        style: TextStyle(
                          fontSize: SizeConfig.h4Size,
                          fontFamily: 'Nunito-Sans',
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2,
                          right: SizeConfig.blockSizeHorizontal * 2,
                        ),
                        child: Text(
                          "\$${widget.product.price}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.subtitleSize,
                            fontFamily: 'Poppins',
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 1.3,
              right: SizeConfig.safeBlockVertical * 1.3,
            ),
            child: FavoriteButton(
              valueChanged: _toggleFavorite,
              iconSize: SizeConfig.safeBlockVertical * 5.7,
              isFavorite: isFavorite,
              iconColor: isFavorite ? Colors.red : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
