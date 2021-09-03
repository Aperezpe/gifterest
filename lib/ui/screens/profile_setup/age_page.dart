import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/interests/set_interests_page.dart';
import 'package:gifterest/ui/screens/my_friends/format.dart';
import 'package:gifterest/ui/screens/my_friends/widgets/platform_date_picker.dart';
import 'package:gifterest/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gifterest/extensions/age_calculator.dart';

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
    SizeConfig().init(context);
    final is800Hight = SizeConfig.screenHeight >= 800;
    final is700Wide = SizeConfig.screenWidth >= 700;
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
            SizedBox(
              height: is700Wide
                  ? SizeConfig.safeBlockVertical * 4
                  : SizeConfig.safeBlockVertical * 5,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: SizeConfig.safeBlockVertical * 5,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.safeBlockHorizontal * 3),
                    child: TextButton(
                      child: Text(
                        "Next".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: SizeConfig.h4Size,
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
              padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 8,
                right: SizeConfig.safeBlockHorizontal * 8,
              ),
              child: Text(
                "What is your birthday?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 5,
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
            SizedBox(height: SizeConfig.safeBlockVertical * 3),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 8,
                  right: SizeConfig.safeBlockHorizontal * 8,
                ),
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
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Container(
      height: is700Wide
          ? SizeConfig.safeBlockVertical * 9
          : SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.black.withOpacity(.38),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.safeBlockHorizontal * 5,
          right: SizeConfig.safeBlockHorizontal * 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${dateFormatted['month']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: is700Wide
                    ? SizeConfig.safeBlockVertical * 2.5
                    : SizeConfig.safeBlockVertical * 3,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
            Text(
              "${dateFormatted['day']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: is700Wide
                    ? SizeConfig.safeBlockVertical * 2.5
                    : SizeConfig.safeBlockVertical * 3,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
            Text(
              "${dateFormatted['year']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: is700Wide
                    ? SizeConfig.safeBlockVertical * 2.5
                    : SizeConfig.safeBlockVertical * 3,
                fontFamily: 'Poppins',
              ),
            ),
            Expanded(child: Container()),
            Icon(
              Icons.expand_more,
              size: SizeConfig.safeBlockVertical * 4.5,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
