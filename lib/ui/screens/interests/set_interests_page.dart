import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/interests/models/set_interests_page_model.dart';
import 'package:bonobo/ui/screens/interests/widgets/clickable_box.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../models/interest.dart';

class SetInterestsPage extends StatelessWidget {
  SetInterestsPage({
    @required this.model,
    @required this.mainPage,
  });
  final SetInterestsPageModel model;
  final Widget mainPage;

  bool get isReadyToSubmit => model.isReadyToSubmit;
  Person get person => model.person;

  static Future<void> show(
    BuildContext context, {
    @required Person person,
    // @required FirestoreDatabase database,
    List<SpecialEvent>
        friendSpecialEvents, // TODO: shape so that friendSpecialEvents is not needed if isUser
    bool isNewFriend: false,
    @required List<SpecialEvent> onDeleteSpecialEvents,
    @required Widget mainPage,
  }) async {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<SetInterestsPageModel>(
          create: (context) => SetInterestsPageModel(
            database: database,
            person: person,
            isNewFriend: isNewFriend,
            friendSpecialEvents: friendSpecialEvents,
            onDeleteSpecialEvents: onDeleteSpecialEvents,
          ),
          child: Consumer<SetInterestsPageModel>(
            builder: (context, model, __) => SetInterestsPage(
              model: model,
              mainPage: mainPage,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    try {
      await model.submit();

      Navigator.of(context).push(PageTransition(
        type: PageTransitionType.fade,
        child: mainPage,
      ));
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Displays loading screen

    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Interests"),
        actions: model.selectedInterests.isNotEmpty
            ? [
                TextButton(
                  child: Text(
                    'Deselect All',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: model.deselectAll,
                )
              ]
            : [],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildContent(),
          BottomButton(
            text: model.submitButtonText,
            onPressed: isReadyToSubmit ? () => _submit(context) : null,
            color: Colors.orange[600],
            disableColor: Colors.grey,
            padding: EdgeInsets.fromLTRB(25, 0, 25, 50),
            textColor: isReadyToSubmit ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<Interest>>(
      stream: model.queryInterestsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data.sort((a, b) => a.name.compareTo(b.name));
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 120),
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return _buildInterestCard(context, snapshot.data[index]);
            },
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildInterestCard(BuildContext context, Interest interest) {
    return ClickableInterest(
      interest: interest,
      onTap: () => model.tapInterest(interest),
      isSelected: model.isSelected(interest.name),
    );
  }
}
