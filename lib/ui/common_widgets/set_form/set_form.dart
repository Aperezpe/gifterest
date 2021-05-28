import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/common_widgets/app_bar_button.dart';
import 'package:bonobo/ui/common_widgets/bottom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/custom_text_field.dart';
import 'package:bonobo/ui/common_widgets/platform_dropdown/platform_dropdown.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form_model.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/set_special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/platform_date_picker.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bonobo/extensions/string_truncator.dart';

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
    await Navigator.of(context).push(
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

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameFocusNode = FocusNode();
    _ageFocusNode = FocusNode();
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
          child: widget.mainPage,
        ));
      } on PlatformException catch (e) {
        PlatformExceptionCustomDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _nameEditingComplete() {
    final newFocus = _model.name.isNotEmpty ? _ageFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  String get appBarText {
    if (_isUser) return "Edit Profile";
    return _isNewFriend ? "New Friend" : "Edit Friend";
  }

  String get floatingActionbuttonText {
    if (_isUser) return "Choose Interests";
    final String name = _person?.name;
    return _isNewFriend
        ? "Add Events"
        : 'Edit ${name.truncateWithEllipsis(10)}\'s Events';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: appBarText,
          leading: AppBarButton(
            icon: LineIcons.times,
            onTap: () => Navigator.of(context).pop(),
          ),
          actions: _isNewFriend
              ? []
              : [
                  TextButton(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: SizeConfig.h4Size,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _onSave,
                  ),
                ],
        ),
        body: _buildContent(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BottomButton(
          onPressed: _onNextPage,
          color: _isUser ? Colors.pink : Colors.blue,
          text: floatingActionbuttonText,
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final is700Wide = SizeConfig.screenWidth >= 700;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: is700Wide
                ? EdgeInsets.fromLTRB(
                    SizeConfig.safeBlockHorizontal * 8,
                    SizeConfig.safeBlockVertical * 3,
                    SizeConfig.safeBlockHorizontal * 8,
                    0,
                  )
                : EdgeInsets.fromLTRB(16, 8, 16, 0),
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
        initialValue: _person?.name ?? "",
        labelText: "Name",
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _model.updateName(value),
        onChanged: (value) => _model.updateName(value),
        onEditingComplete: _nameEditingComplete,
      ),
      SizedBox(height: SizeConfig.safeBlockVertical * 2),
      _isUser
          ? PlatformDatePicker(
              initialDate: _model.dob,
              selectedDate: _model.dob,
              selectDate: (dob) => _model.changeDob(dob),
            )
          : CustomTextField(
              focusNode: _ageFocusNode,
              initialValue: _model?.age != null ? '${_model.age}' : "",
              textInputAction: TextInputAction.done,
              labelText: "Age",
              keyboardType: TextInputType.numberWithOptions(),
              validator: (value) {
                final int age = int.tryParse(value) ?? 0;
                final bool isDigit = age > 0 ? true : false;
                return (value.isNotEmpty && isDigit) ? null : "Invalid Age";
              },
              onSaved: (value) => _model.updateAge(int.tryParse(value) ?? 0),
              onChanged: (value) => _model.updateAge(int.tryParse(value) ?? 0),
            ),
      SizedBox(height: SizeConfig.safeBlockVertical * 2),
      PlatformDropdown(
        initialValue: _model.genderTypes[_model.initialGenderValue],
        values: _model.genderTypes,
        onChanged: _model.onGenderDropdownChange,
        title: "Choose Gender",
      ),
    ];
  }
}
