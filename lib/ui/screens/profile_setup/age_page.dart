import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/custom_text_field.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgePage extends StatefulWidget {
  const AgePage({Key key, @required this.user}) : super(key: key);

  final Person user;

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  GlobalKey<FormState> _formKey;

  int _age;

  void _onSubmit(BuildContext context) async {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    if (_validateAndSaveForm()) {
      widget.user.age = _age;

      SetInterestsPage.show(
        context,
        person: widget.user,
        mainPage: MyProfilePage(),
        onDeleteSpecialEvents: [],
        firebaseStorage: FirebaseUserStorage(uid: database.uid),
      );
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border(bottom: BorderSide.none),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 80),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "What is your age?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: "Age",
                onChanged: (value) => _age = int.tryParse(value) ?? 0,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                errorText: "Invalid age",
                validator: (value) {
                  final int age = int.tryParse(value) ?? 0;
                  final bool isDigit = age > 0 ? true : false;
                  return (value.isNotEmpty && isDigit) ? null : "Invalid Age";
                },
              ),
              Expanded(child: Container()),
              CustomButton(
                  text: "Set Interests 😍",
                  onPressed: () => _onSubmit(context)),
            ],
          ),
        ),
      ),
    );
  }
}
