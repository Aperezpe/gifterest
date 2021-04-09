import 'dart:io';

import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/add_event_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

import 'models/set_special_event_model.dart';

// TODO: Prevent user from deleting all events for a friend, cz this will cause
// errors when sorting friends by upcoming events
class SetSpecialEvent extends StatelessWidget {
  SetSpecialEvent({@required this.model});
  final SetSpecialEventModel model;

  static Widget show(
    BuildContext context, {
    @required Person person,
    @required bool isNewFriend,
    @required FirebaseFriendStorage firebaseFriendStorage,
    File selectedImage,
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
              firebaseStorageService: firebaseFriendStorage,
              selectedImage: selectedImage,
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
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: _model.database.eventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data.map((e) => e.name).toList();
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(_isNewFriend ? "New Friend" : 'Edit Friend'),
              actions: _buildActions(events, context),
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildContent(events),
                BottomButton(
                  text: _isNewFriend
                      ? "Add Interests 😍"
                      : 'Edit ${_person.name}\'s Interests 😍',
                  onPressed: _model.isEmpty ||
                          _model.firebaseStorageService?.uploadTask != null
                      ? null
                      : () => _model.goToInterestsPage(context),
                  color: Colors.pink,
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 50),
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
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () => _onSave(context),
      ),
      TextButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _model.addSpecialEvent(events),
      ),
    ];

    return _isNewFriend ? [actions[1]] : actions;
  }

  Widget _buildContent(List<String> events) {
    if (_model.firebaseStorageService?.uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: _model.firebaseStorageService.uploadTask.snapshotEvents,
        builder: (context, snapshot) => LoadingScreen(),
      );
    } else {
      final specialEvents = _model.friendSpecialEvents;
      return ListView(
        padding: EdgeInsets.only(bottom: 120),
        children: [
          for (var specialEvent in specialEvents)
            AddEventCard(
              key: ValueKey(specialEvent.id),
              index: _model.friendSpecialEvents.indexOf(specialEvent),
              events: events,
              model: _model,
              specialEvent: specialEvent,
            ),
        ],
      );
    }
  }
}
