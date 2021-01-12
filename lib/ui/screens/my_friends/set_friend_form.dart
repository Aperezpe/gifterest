import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/screens/my_friends/models/set_friend_model.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/dropdown_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/loading_screen.dart';

import 'models/friend.dart';

class SetFriendForm extends StatefulWidget {
  SetFriendForm({@required this.model});
  final model;

  static Future<void> show(
    BuildContext context, {
    Friend friend,
    List<SpecialEvent> friendSpecialEvents,
  }) async {
    final database = Provider.of<Database>(context);
    final auth = Provider.of<AuthBase>(context);
    final user = await auth.currentUser();
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => StreamBuilder<List<Gender>>(
            stream: database.genderStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ChangeNotifierProvider<SetFriendModel>(
                  create: (context) => SetFriendModel(
                    uid: user.uid,
                    database: database,
                    friend: friend,
                    friendSpecialEvents: friendSpecialEvents,
                    genders: snapshot.data,
                  ),
                  child: Consumer<SetFriendModel>(
                    builder: (context, model, __) => SetFriendForm(
                      model: model,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("An error has ocurred"));
              }
              return LoadingScreen();
            }),
      ),
    );
  }

  @override
  _SetFriendFormState createState() => _SetFriendFormState();
}

class _SetFriendFormState extends State<SetFriendForm> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();

  SetFriendModel get _model => widget.model;
  Friend get _friend => _model.friend;
  bool get _isNewFriend => _model.isNewFriend;

  String _name = "";
  int _age;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _onSetEvent() {
    if (_validateAndSaveForm()) {
      _model.goToSpecialEvents(context);
    }
  }

  void _onSave() async {
    if (_validateAndSaveForm()) {
      try {
        await _model.onSave();
        Navigator.pop(context);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _nameEditingComplete() {
    final newFocus = _name.isNotEmpty ? _ageFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<Widget> _getImageWidget() async {
    if (_model.selectedImage != null) {
      return Image.file(
        _model.selectedImage,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

    return (_isNewFriend)
        ? Image.asset(
            'assets/placeholder.jpg',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
        : _model.downloadProfileImageURL();
  }

  /// Initialize values on form if editing friend
  @override
  void initState() {
    super.initState();
    _name = _friend?.name;
    _age = _friend?.age;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    // Display a loading screen if image is uploading
    if (_model.firebaseStorage?.uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _model.firebaseStorage.uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingScreen(),
              Text('${(progressPercent * 100).toStringAsFixed(2)}'),
            ],
          );
        },
      );
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 100,
                        child: FutureBuilder(
                          future: _getImageWidget(),
                          builder: (context, snapshot) =>
                              snapshot.connectionState == ConnectionState.done
                                  ? snapshot.data
                                  : Container(),
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: _model.pickImage,
                        child: Text("Select Image"),
                      ),
                    ),
                    ..._buildFormFields()
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 2.0,
        title: Text(_isNewFriend ? "New Friend" : 'Edit Friend'),
        actions: _isNewFriend
            ? []
            : [
                FlatButton(
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: _onSave,
                ),
              ],
      ),
      body: _buildContent(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomButton(
        onPressed: _onSetEvent,
        color: Colors.blue,
        text: _isNewFriend
            ? "Add Events 👉"
            : 'Edit ${_friend.name}\'s Events 👉',
        textColor: Colors.white,
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        initialValue: _name,
        decoration: InputDecoration(
          labelText: 'Name',
        ),
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _model.updateName(value),
        onChanged: (value) => _model.updateName(value),
        onEditingComplete: _nameEditingComplete,
      ),
      TextFormField(
        focusNode: _ageFocusNode,
        initialValue: _age?.toString(),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(labelText: 'Age'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) => value.isNotEmpty ? null : "Age can't be empty",
        onSaved: (value) => _model.updateAge(int.tryParse(value) ?? 0),
        onChanged: (value) => _model.updateAge(int.tryParse(value) ?? 0),
      ),
      SizedBox(height: 15.0),
      DropdownList(
        dropdownValue: _model.genderDropdownValue,
        items: [
          for (int i = 0; i < _model.genders.length; i++)
            DropdownMenuItem(
              child: Text(_model.genders[i].type),
              value: i,
            )
        ],
        onChanged: _model.onGenderDropdownChange,
      ),
    ];
  }
}
