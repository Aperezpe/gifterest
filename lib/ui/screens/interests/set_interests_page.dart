import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/app_bar_button.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/interests/models/set_interests_page_model.dart';
import 'package:bonobo/ui/screens/interests/widgets/clickable_box.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
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
    List<SpecialEvent> friendSpecialEvents,
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
      PlatformExceptionCustomDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Displays loading screen

    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Interests",
        leading: AppBarButton(
          icon: LineIcons.angleLeft,
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: model.selectedInterests.isNotEmpty
            ? [
                TextButton(
                  child: Text(
                    'RESTART',
                    style: TextStyle(
                      fontSize: SizeConfig.h4Size,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
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
            color: Color(0xffFF9E0A),
            disableColor: Colors.grey,
            padding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 5,
              0,
              SizeConfig.safeBlockHorizontal * 5,
              SizeConfig.safeBlockVertical * 3.5,
            ),
            textColor: isReadyToSubmit ? Colors.white : Colors.white70,
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
          return LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            return GridView.builder(
              padding: EdgeInsets.fromLTRB(
                maxWidth / 40,
                maxWidth / 40,
                maxWidth / 40,
                maxHeight / 6,
              ),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: maxWidth / 40,
                crossAxisSpacing: maxWidth / 40,
              ),
              itemBuilder: (context, index) {
                return _buildInterestCard(context, snapshot.data[index]);
              },
            );
          });
        }
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
        }
        return LoadingScreen();
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
