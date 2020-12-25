import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/add_event_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';
import 'models/set_special_event_model.dart';

class SetSpecialEvent extends StatefulWidget {
  SetSpecialEvent({@required this.model});
  final SetSpecialEventModel model;

  static Future<void> show(
    BuildContext context, {
    @required Friend friend,
    @required FirestoreDatabase database,
    @required bool isNewFriend,
    @required List<SpecialEvent> friendSpecialEvents,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<SetSpecialEventModel>(
          create: (context) => SetSpecialEventModel(
            database: database,
            friend: friend,
            friendSpecialEvents: friendSpecialEvents,
            isNewFriend: isNewFriend,
          ),
          child: Consumer<SetSpecialEventModel>(
            builder: (context, model, _) => SetSpecialEvent(
              model: model,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _SetSpecialEventState createState() => _SetSpecialEventState();
}

class _SetSpecialEventState extends State<SetSpecialEvent> {
  SetSpecialEventModel get _model => widget.model;
  Friend get _friend => _model.friend;
  bool get _isNewFriend => _model.isNewFriend;

  void _onSave() async {
    try {
      await _model.onSave();
      Navigator.popUntil(context, (route) => route.isFirst);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // _model.initializeFriendSpecialEvents();
  }

  // Return [Add] or [Save, Add] if is New Friend or Edit Friend respectively
  List<Widget> _buildActions(List<Event> events) {
    final actions = [
      FlatButton(
        child: Text(
          'Save',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: _onSave,
      ),
      FlatButton(
        child: Text(
          'Add',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () => _model.addSpecialEvent(events),
      ),
    ];

    return _isNewFriend ? [actions[1]] : actions;
  }

  Widget _buildContent(List<Event> events) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _model.friendSpecialEvents
            .map(
              (specialEvent) => AddEventCard(
                index: _model.friendSpecialEvents.indexOf(specialEvent),
                events: events,
                model: _model,
                specialEvent: specialEvent,
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
        stream: _model.database.eventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final events = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text(_isNewFriend ? "New Friend" : 'Edit Friend'),
                actions: _buildActions(events),
              ),
              body: _buildContent(events),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: BottomButton(
                onPressed: _model.isEmpty
                    ? null
                    : () => _model.goToInterestsPage(context),
                color: Colors.pink,
                text: _isNewFriend
                    ? "Add Interests 😍"
                    : 'Edit ${_friend.name}\'s Interests 😍',
                textColor: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          return CircularProgressIndicator();
        });
  }
}
