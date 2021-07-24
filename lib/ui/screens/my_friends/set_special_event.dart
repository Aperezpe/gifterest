import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/app_bar_button.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/add_event_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bonobo/extensions/string_truncator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'models/set_special_event_model.dart';

class SetSpecialEvent extends StatelessWidget {
  SetSpecialEvent({@required this.model});
  final SetSpecialEventModel model;

  static Widget show(
    BuildContext context, {
    @required Person person,
    @required bool isNewFriend,
  }) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<SpecialEvent>>(
      stream: database.specialEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allSpecialEvents = snapshot.data;

          return ChangeNotifierProvider<SetSpecialEventModel>(
            create: (context) => SetSpecialEventModel(
              database: database,
              person: person,
              allSpecialEvents: allSpecialEvents,
              isNewFriend: isNewFriend,
            ),
            child: Consumer<SetSpecialEventModel>(
              builder: (context, model, _) => SetSpecialEvent(
                model: model,
              ),
            ),
          );
        }
        return LoadingScreen();
      },
    );
  }

  SetSpecialEventModel get _model => model;
  Person get _person => _model.person;
  bool get _isNewFriend => _model.isNewFriend;

  void _onSave(BuildContext context) async {
    try {
      await _model.onSave();
      Navigator.of(context).push(PageTransition(
        type: PageTransitionType.fade,
        child: MyFriendsPage(),
      ));
    } on PlatformException catch (e) {
      PlatformExceptionCustomDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  void _addSpecialEvents(BuildContext context, List<String> events) {
    _model.addSpecialEvent(events);
    final newEventNumber = model.friendSpecialEvents.length;

    // Use this code to show a dark snackbar
    // CustomSnackBar.success(
    //   message: "Event $newEventNumber added at the bottom!",
    //   textStyle: TextStyle(
    //     fontSize: SizeConfig.safeBlockVertical * 2.3,
    //     fontWeight: FontWeight.w600,
    //     color: Colors.white,
    //   ),
    //   backgroundColor: Colors.black54,
    //   icon: Icon(
    //     LineIcons.calendar,
    //     color: Colors.transparent,
    //   ),
    // );

    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: "Event $newEventNumber added at the bottom!",
        textStyle: TextStyle(
          fontSize: SizeConfig.subtitleSize,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        backgroundColor: Colors.white.withOpacity(.9),
        icon: Icon(
          LineIcons.calendarCheck,
          color: Colors.transparent,
        ),
      ),
      displayDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<List<Event>>(
      stream: _model.database.eventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data.map((e) => e.name).toList();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: _isNewFriend ? "New Friend" : 'Edit Friend',
              actions: _buildActions(events, context),
              leading: AppBarButton(
                icon: LineIcons.angleLeft,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildContent(events),
                BottomButton(
                  text: _isNewFriend
                      ? "Add Interests"
                      : 'Edit ${_person.name.truncateWithEllipsis(10)}\'s Interests',
                  onPressed: () => _model.goToInterestsPage(context),
                  color: Colors.pink,
                  padding: EdgeInsets.fromLTRB(
                    SizeConfig.safeBlockHorizontal * 5,
                    0,
                    SizeConfig.safeBlockHorizontal * 5,
                    SizeConfig.safeBlockVertical * 4,
                  ),
                  textColor: Colors.white,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }
        return LoadingScreen();
      },
    );
  }

  // Return [Add] or [Save, Add] actions if is New Friend or
  // Edit Friend respectively
  List<Widget> _buildActions(List<String> events, BuildContext context) {
    final actions = [
      TextButton(
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: SizeConfig.h4Size,
            color: Colors.white,
          ),
        ),
        onPressed: () => _onSave(context),
      ),
      AppBarButton(
        icon: LineIcons.plus,
        onTap: () => _addSpecialEvents(context, events),
        padding: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2),
      )
    ];

    return _isNewFriend ? [actions[1]] : actions;
  }

  Widget _buildContent(List<String> events) {
    final specialEvents = _model.friendSpecialEvents;

    // Disable the delete button when theres only one card to enforce user to
    // input at least one event, so that list is able to sort in MyFriendsPage
    bool disableDelete = false;
    if (specialEvents.length == 1) disableDelete = true;

    return ListView(
      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 18),
      children: [
        for (var specialEvent in specialEvents)
          AddEventCard(
            key: ValueKey(specialEvent.id),
            index: _model.friendSpecialEvents.indexOf(specialEvent),
            events: events,
            model: _model,
            disableDelete: disableDelete,
            specialEvent: specialEvent,
          ),
      ],
    );
  }
}
