import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/screens/interests/models/set_interests_page_model.dart';
import 'package:bonobo/ui/screens/interests/widgets/clickable_box.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/interest.dart';

class SetInterestsPage extends StatelessWidget {
  SetInterestsPage({
    @required this.model,
  });
  final SetInterestsPageModel model;

  bool get isReadyToSubmit => model.isReadyToSubmit;

  static Future<void> show(
    BuildContext context, {
    @required Friend friend,
    @required FirestoreDatabase database,
    @required List<SpecialEvent> friendSpecialEvents,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<SetInterestsPageModel>(
          create: (context) => SetInterestsPageModel(
            database: database,
            friend: friend,
            friendSpecialEvents: friendSpecialEvents,
          ),
          child: Consumer<SetInterestsPageModel>(
            builder: (context, model, __) => SetInterestsPage(
              model: model,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit(BuildContext context) async {
    try {
      await model.submit();
      Navigator.popUntil(context, (route) => route.isFirst);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interests"),
      ),
      body: _buildContent(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomButton(
        onPressed: isReadyToSubmit ? () => submit(context) : null,
        color: isReadyToSubmit ? Colors.orange[600] : Colors.grey,
        text: model.submitButtonText,
        textColor: isReadyToSubmit ? Colors.black : Colors.white,
        disableColor: Colors.grey,
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<Interest>>(
      stream: model.interestStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final interests = snapshot.data;
          final children = interests
              .map(
                (interest) => ClickableInterest(
                  interest: interest,
                  onTap: () => model.tapInterest(interest.nameId),
                  color: model.isSelected(interest.nameId)
                      ? Colors.pink
                      : Colors.white,
                ),
              )
              .toList();

          return GridView.count(
            crossAxisCount: 2,
            children: children,
            padding: EdgeInsets.fromLTRB(15, 15, 15, 80),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Some error occured"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
