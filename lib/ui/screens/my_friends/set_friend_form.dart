import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/bottom_clickable.dart';
import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/screens/interests/interests_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';

class SetFriendForm extends StatefulWidget {
  SetFriendForm({
    @required this.database,
    this.friend,
    @required this.uid,
  });
  final Database database;
  final Friend friend;
  final String uid;

  static Future<void> show(BuildContext context, {Friend friend}) async {
    final database = Provider.of<Database>(context);
    final auth = Provider.of<AuthBase>(context);
    final user = await auth.currentUser();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetFriendForm(
          database: database,
          friend: friend,
          uid: user.uid,
        ),
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

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final friends = await widget.database.friendsStream().first;
        final allNames = friends.map((friend) => friend.name).toList();
        if (widget.friend != null) {
          allNames.remove(widget.friend.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different friend name',
            defaultAtionText: 'OK',
          ).show(context);
          FocusScope.of(context).unfocus();
        } else {
          final id = widget.friend?.id ?? documentIdFromCurrentDate();
          final friend = Friend(
            id: id,
            uid: widget.uid,
            name: _name,
            age: _age,
          );

          await widget.database.setFriend(friend);
          Navigator.of(context).pop();
        }
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

  @override
  void initState() {
    super.initState();
    _name = widget.friend?.name;
    _age = widget.friend?.age;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.friend == null ? "New Friend" : 'Edit Friend'),
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomClickable(
        text: widget.friend == null
            ? "Add Interests"
            : 'Edit ${widget.friend.name}\'s Interests',
        onTap: () => InterestsPage.show(context, database: widget.database),
        color: Colors.pink,
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFromChildren(),
      ),
    );
  }

  List<Widget> _buildFromChildren() {
    return [
      TextFormField(
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        initialValue: _name,
        decoration: InputDecoration(
          labelText: 'Name',
        ),
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value,
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
        onSaved: (value) => _age = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
