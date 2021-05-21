import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/drawer_button_builder.dart';
import 'package:bonobo/ui/common_widgets/empty_content.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/clickable_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key key}) : super(key: key);

  static String get routeName => 'favorites-page';

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    SizeConfig().init(context);

    final is700Wide = SizeConfig.screenWidth >= 700;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Favorites",
        leading: DrawerButtonBuilder(),
      ),
      drawer: AppDrawer(
        currentChildRouteName: routeName,
      ),
      body: StreamBuilder<List<Product>>(
        stream: database.favoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data;
            return favorites.isEmpty
                ? EmptyContent(
                    assetPath: 'assets/sad_monkey2.png',
                    imageWidth: 150,
                    title: "Oh crap, you've got nothing yet",
                    message: "",
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 2,
                      SizeConfig.safeBlockVertical * 2,
                      SizeConfig.safeBlockHorizontal * 2,
                      SizeConfig.safeBlockVertical * 2,
                    ),
                    itemCount: favorites.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: is700Wide ? 3 : 2,
                      childAspectRatio: .9,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return ClickableProduct(
                        key: Key("product-box-${favorites[index].id}"),
                        product: favorites[index],
                        favorites: favorites,
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
