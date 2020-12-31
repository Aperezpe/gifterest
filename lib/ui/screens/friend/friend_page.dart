import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/circle_image_button.dart';
import 'package:bonobo/ui/common_widgets/grid_item_builder.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/friend/widgets/clickable_product.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:bonobo/ui/screens/friend/widgets/range_slider.dart';
import 'package:bonobo/ui/screens/friend/widgets/tabs.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/style/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../style/fontStyle.dart';
import 'models/friend_page_model.dart';

class FriendPage extends StatelessWidget {
  FriendPage({@required this.model});
  final FriendPageModel model;

  static Future<void> show(
    BuildContext context, {
    @required Friend friend,
    @required List<SpecialEvent> friendSpecialEvents,
    @required FirestoreDatabase database,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<FriendPageModel>(
          create: (context) => FriendPageModel(
            database: database,
            friend: friend,
            friendSpecialEvents: friendSpecialEvents,
          ),
          child: Consumer<FriendPageModel>(
            builder: (context, model, __) => FriendPage(
              model: model,
            ),
          ),
        ),
      ),
    );
  }

  Friend get friend => model.friend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(model.profileImageUrl),
                  ),
                ),
              ),
              BudgetSlider(model: model),
              Tabs(model: model),
              _buildRecommendations(),
            ],
          ),
        ),
      ),
    );
  }

  _buildRecommendations() {
    return StreamBuilder<List<Product>>(
      stream: model.queryProductsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> content = [];
          for (var interestName in friend.interests) {
            List<Product> products =
                model.queryProducts(snapshot.data, interestName);

            if (products.isEmpty)
              content.addAll([
                Container(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(interestName, style: h3),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text("Oops! nothing found"),
                ),
              ]);
            else
              content.addAll([
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(interestName, style: h3),
                ),
                GridView.builder(
                  padding: EdgeInsets.all(15.0),
                  itemCount: products.length,
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ClickableProduct(
                      onTap: () {},
                      product: products[index],
                    );
                  },
                ),
              ]);
          }
          return Column(children: content);
        }
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
