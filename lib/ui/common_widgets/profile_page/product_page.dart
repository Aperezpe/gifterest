import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/app_bar_button.dart';
import 'package:gifterest/ui/common_widgets/custom_app_bar.dart';
import 'package:gifterest/ui/common_widgets/custom_button.dart';
import 'package:gifterest/ui/common_widgets/favorite_button.dart';
import 'package:gifterest/ui/models/product.dart';
import 'package:gifterest/ui/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final ValueChanged<bool> onChanged;

  ProductPage({
    Key key,
    this.product,
    this.onChanged,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final favoritesController = locator.get<FavoritesController>();
  bool get isFavorite => favoritesController.isFavorite[widget.product.id];

  @override
  void initState() {
    super.initState();
  }

  _launchURL() async {
    String url = widget.product.itemUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _toggleFavorite(bool isFavorite) async {
    final database = Provider.of<Database>(context, listen: false);
    favoritesController.isFavorite[widget.product.id] =
        !favoritesController.isFavorite[widget.product.id];

    if (isFavorite) {
      await database.setFavorite(widget.product);
    } else {
      await database.deleteFavorite(widget.product);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        leading: AppBarButton(
          icon: LineIcons.times,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: widget.product.name,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Center(
                    child: Image.network(
                      widget.product.imageUrl,
                      height: SizeConfig.screenHeight / 2.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.safeBlockVertical * 2,
                      right: SizeConfig.safeBlockVertical * 2,
                    ),
                    child: FavoriteButton(
                      valueChanged: _toggleFavorite,
                      iconColor: isFavorite ? Colors.red : Colors.grey[300],
                      isFavorite: isFavorite,
                      iconSize: SizeConfig.safeBlockVertical * 6.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 3),
              Text(
                "\$${widget.product.price}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 4,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Nunito-Sans',
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 2),
              Text(
                widget.product.distributor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2.5,
                ),
              ),
              Text(
                widget.product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 2),
              CustomButton(
                text: 'Check out in store',
                color: Colors.orange,
                onPressed: _launchURL,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical),
              Text(
                "(Paid Link)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizeConfig.subtitleSize),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
                height: SizeConfig.safeBlockVertical * 4,
              ),
              Container(
                child: Text(
                  "Product Rating",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.subtitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical),
              _buildRating(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating() {
    double rating = widget.product.rating;
    int remainingStars = 5;
    List<Widget> stars = [];

    while (rating >= 1) {
      stars.add(Icon(LineIcons.starAlt,
          color: Colors.yellow[700], size: SizeConfig.safeBlockVertical * 3.8));
      remainingStars--;
      rating = rating - 1;
    }
    if (rating != 0) {
      stars.add(Icon(LineIcons.alternateStarHalf,
          color: Colors.yellow[700], size: SizeConfig.safeBlockVertical * 3.8));
      remainingStars--;

      for (int i = 0; i < remainingStars; i++)
        stars.add(
          Icon(LineIcons.star,
              color: Colors.yellow[700],
              size: SizeConfig.safeBlockVertical * 3.8),
        );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }
}
