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
              for (var interest in model.friend.interests)
                ..._buildRecommendations(interest),
            ],
          ),
        ),
      ),
    );
  }

  _buildRecommendations(interest) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 18),
        child: Text(interest, style: h3),
      ),
      StreamBuilder<List<dynamic>>(
        stream: model.productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridItemBuilder<dynamic>(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              crossAxisCount: 2,
              shrinkWrap: true,
              primary: false,
              snapshot: snapshot,
              // filterFunction: filterProducts,
              // filters: {
              //   'interest': interest,
              //   'age': friend.age,
              //   'budget': [model.startValue, model.endValue],
              //   'gender': friend.gender,
              //   'event': model.specialEventsNames[model.selectedTab],
              // },
              itemBuilder: (context, product) =>
                  _buildProductCard(context, product),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ];
  }

  // List<dynamic> filterProducts(List<dynamic> products, dynamic filters) {
  //   for (Product p in products) {
  //     bool isInAgeRange =
  //         filters['age'] >= p.ageRange[0] && filters['age'] <= p.ageRange[1];
  //     bool isGender = filters['gender'];
  //     if (filters['interest'] == p.category) {}
  //   }

  //   return [];
  // }

  _buildProductCard(BuildContext context, Product product) {
    return ClickableProduct(
      onTap: () {},
      product: product,
    );
  }
}
