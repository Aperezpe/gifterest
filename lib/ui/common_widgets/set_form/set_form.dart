import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/custom_text_field.dart';
import 'package:bonobo/ui/common_widgets/platform_dropdown/platform_dropdown.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form_model.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/set_special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/platform_date_picker.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

class SetPersonForm extends StatefulWidget {
  SetPersonForm({
    Key key,
    @required this.model,
    @required this.mainPage,
  }) : super(key: key);
  final SetFormModel model;
  final Widget mainPage;

  static Future<void> create(
    BuildContext context, {
    dynamic person, // It could be Friend or AppUser
    @required Widget mainPage,
  }) async {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return ChangeNotifierProvider<SetFormModel>(
            create: (context) => SetFormModel(
              uid: database.uid,
              database: database,
              isNew: person == null ? true : false,
              person: person,
              genders: locator.get<GenderProvider>().genders,
            ),
            child: Consumer<SetFormModel>(
              builder: (context, model, __) => SetPersonForm(
                model: model,
                mainPage: mainPage,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  _SetPersonFormState createState() => _SetPersonFormState();
}

class _SetPersonFormState extends State<SetPersonForm> {
  GlobalKey<FormState> _formKey;

  FocusNode _nameFocusNode;
  FocusNode _ageFocusNode;

  SetFormModel get _model => widget.model;
  dynamic get _person => _model.person;
  bool get _isNewFriend => _model.isNew;
  bool get _isUser => _model.isUser;

  String _name = "";
  int _age;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameFocusNode = FocusNode();
    _ageFocusNode = FocusNode();
    _name = _person?.name;
    _age = _person?.age;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _onNextPage() {
    if (_validateAndSaveForm()) {
      if (_isUser) {
        SetInterestsPage.show(
          context,
          person: _model.setPerson(),
          mainPage: MyProfilePage(),
          // database: database,
          // friendSpecialEvents: FriendSpecialEvents.getFriendSpecialEvents(updatedPerson, allSpecialEvents),
          isNewFriend: _model.isNew,
          onDeleteSpecialEvents: [],
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SetSpecialEvent.show(
              context,
              person: _model.setPerson(),
              isNewFriend: _model.isNew,
            ),
          ),
        );
      }
    }
  }

  void _onSave() async {
    if (_validateAndSaveForm()) {
      try {
        await _model.onSave();
        Navigator.of(context).push(PageTransition(
          type: PageTransitionType.fade,
          child: widget.mainPage, // TODO: go back to mainPage // done
        ));
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

  String get appBarText {
    if (_isUser) return "Edit Profile";
    return _isNewFriend ? "New Friend" : "Edit Friend";
  }

  String get floatingActionbuttonText {
    if (_isUser) return "Choose Interests 😍";
    return _isNewFriend
        ? "Add Events 👉"
        : 'Edit ${_person.name}\'s Events 👉'; // TODO: This to interests
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: Text(appBarText), // TODO: This to Edig Profile // Done
        actions: _isNewFriend
            ? []
            : [
                TextButton(
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
        onPressed: _onNextPage, // TODO: This to go to InterestsPage // Done
        color: _isUser ? Colors.pink : Colors.blue,
        text: floatingActionbuttonText, // TODO: This to interests // done
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildContent() {
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
                  SizedBox(height: 25),
                  ..._buildFormFields(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      CustomTextField(
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        initialValue: _name,
        labelText: "Name",
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _model.updateName(value),
        onChanged: (value) => _model.updateName(value),
        onEditingComplete: _nameEditingComplete,
      ),
      SizedBox(height: 15),
      _isUser
          ? PlatformDatePicker(
              initialDate: _model.dob,
              selectedDate: _model.dob,
              selectDate: (dob) => _model.changeDob(dob),
            )
          : CustomTextField(
              focusNode: _ageFocusNode,
              initialValue: _age?.toString(),
              textInputAction: TextInputAction.done,
              labelText: "Age",
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              validator: (value) {
                final int age = int.tryParse(value) ?? 0;
                final bool isDigit = age > 0 ? true : false;
                return (value.isNotEmpty && isDigit) ? null : "Invalid Age";
              },
              onSaved: (value) => _model.updateAge(int.tryParse(value) ?? 0),
              onChanged: (value) => _model.updateAge(int.tryParse(value) ?? 0),
            ),
      SizedBox(height: 15.0),
      PlatformDropdown(
        initialValue: _model.genderTypes[_model.initialGenderValue],
        values: _model.genderTypes,
        onChanged: _model.onGenderDropdownChange,
        title: "Choose Gender",
      ),
    ];
  }
}
