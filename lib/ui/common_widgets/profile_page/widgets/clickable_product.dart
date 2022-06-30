import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/common_widgets/favorite_button.dart';
import 'package:gifterest/ui/models/product.dart';
import 'package:gifterest/ui/common_widgets/profile_page/product_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ClickableProduct extends StatefulWidget {
  ClickableProduct({
    @required this.key,
    @required this.product,
    @required this.favorites,
    @required this.valueChanged,
    @required this.isFavorite,
    this.isUser: true,
  }) : super(key: key);

  final Key key;
  final Product product;
  final List<Product> favorites;
  final bool isFavorite;
  final Function valueChanged;
  final bool isUser;

  @override
  _ClickableProductState createState() => _ClickableProductState();
}

class _ClickableProductState extends State<ClickableProduct> {
  bool showProductDetails = false;

  List<Product> get favorites => widget.favorites;

  @override
  void initState() {
    super.initState();
  }

  void _showProductDetails() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductPage(
          product: widget.product,
          valueChanged: (isFavorite) => widget.valueChanged(isFavorite),
          favorites: favorites,
          isFavorite: widget.isFavorite,
        ),
      ),
    );
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
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeVertical * 2,
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
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
              valueChanged: (isFavorite) => widget.valueChanged(isFavorite),
              iconSize: SizeConfig.safeBlockVertical * 5.7,
              isFavorite: widget.isFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
