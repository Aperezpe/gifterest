import 'package:bonobo/ui/models/app_user.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/format.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/platform_date_picker.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bonobo/extensions/age_calculator.dart';

class AgePage extends StatefulWidget {
  const AgePage({Key key, @required this.user}) : super(key: key);

  final AppUser user;

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  DateTime _selectedDate;

  void _onNext(BuildContext context) {
    DateTime dob = _selectedDate;
    widget.user.dob = dob;
    widget.user.age = dob.getAge(dob);

    SetInterestsPage.show(
      context,
      person: widget.user,
      mainPage: MyProfilePage(),
      onDeleteSpecialEvents: [],
    );

    print(widget.user.age);
  }

  @override
  void initState() {
    _selectedDate = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff599BF9),
              Color(0xffBF4EF9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 38,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: TextButton(
                      child: Text(
                        "Next".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () => _onNext(context),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                "What is your birthday?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      offset: Offset(1, 4),
                      color: Colors.black.withOpacity(.25),
                      blurRadius: 4,
                    ),
                  ],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(height: 30),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: PlatformDatePicker(
                  initialDate: DateTime.now(),
                  selectedDate: _selectedDate,
                  selectDate: (date) => setState(() => _selectedDate = date),
                  dropdownButton: (selectedDate) =>
                      _buildDropdownButton(selectedDate),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(DateTime selectedDate) {
    final dateFormatted = Format.dateToMap(selectedDate);
    return Container(
      height: 63,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black.withOpacity(.38),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${dateFormatted['month']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 15),
            Text(
              "${dateFormatted['day']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: 15),
            Text(
              "${dateFormatted['year']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            Expanded(child: Container()),
            Icon(
              Icons.expand_more,
              size: 36,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
