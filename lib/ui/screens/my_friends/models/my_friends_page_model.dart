import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/material.dart';

class MyFriendsPageModel extends ChangeNotifier {
  MyFriendsPageModel({
    @required this.database,
    @required this.allSpecialEvents,
  });

  final FirestoreDatabase database;
  final List<SpecialEvent> allSpecialEvents;

  void deleteFriend(BuildContext context, Friend friend) async {
    final res = await PlatformAlertDialog(
      title: "Delete?",
      content: "Are you sure want to delete ${friend.name}?",
      defaultAtionText: "Yes",
      cancelActionText: "Cancel",
    ).show(context);

    try {
      if (res) {
        final storageService =
            FirebaseStorageService(uid: database.uid, friend: friend);

        await storageService.deleteFriendProfileImage();
        database.deleteFriend(friend);
        for (SpecialEvent event in allSpecialEvents) {
          if (event.friendId == friend.id) {
            database.deleteSpecialEvent(event);
          }
        }
      }
    } catch (e) {
      await PlatformAlertDialog(
        title: "Error",
        content: "Something went wrong",
        defaultAtionText: "Ok",
      ).show(context);
    }
  }

  List<SpecialEvent> getFriendSpecialEvents(Friend friend) {
    List<SpecialEvent> friendSpecialEvents = allSpecialEvents
        .where((event) => event.friendId == friend?.id)
        .toList();
    if (friendSpecialEvents.isEmpty) return [];
    return friendSpecialEvents;
  }
}
