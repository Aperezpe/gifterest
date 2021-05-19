import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FriendListTile extends StatefulWidget {
  FriendListTile({
    Key key,
    @required this.onTap,
    @required this.person,
    this.editAction,
    this.deleteAction,
    @required this.model,
  }) : super(key: key);
  final VoidCallback onTap;
  final VoidCallback editAction;
  final VoidCallback deleteAction;
  final Person person;
  final MyFriendsPageModel model;

  @override
  _FriendListTileState createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  String dropdownValue = 'Edit';

  int get remainingDays {
    if (widget.model.upcomingEvents.containsKey(widget.person.id)) {
      return Dates.getRemainingDays(
          widget.model.upcomingEvents[widget.person.id].elementAt(0).date);
    }
    return -1;
  }

  String get mostRescentEvent =>
      widget.model.upcomingEvents[widget.person.id].elementAt(0).name;

  Color get remainingDaysColor {
    if (remainingDays <= 14)
      return Colors.red;
    else if (remainingDays <= 30) return Color.fromRGBO(255, 204, 0, 1);
    return Colors.green;
  }

  String get daysText {
    if (remainingDays == 0) {
      return "Today";
    } else if (remainingDays == 1) {
      return "Day";
    }
    return "Days";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    if (remainingDays == -1) return Container();
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: is700Wide
          ? Stack(
              alignment: Alignment.topRight,
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      height: SizeConfig.safeBlockVertical * 12,
                      padding: EdgeInsets.all(8),
                      child: _buildTabletContent(),
                    ),
                  ),
                ),
                Positioned(
                  top: SizeConfig.safeBlockVertical,
                  right: SizeConfig.safeBlockHorizontal * 2,
                  child: DropdownButton<String>(
                    onChanged: (newValue) {
                      if (newValue == 'Edit')
                        widget.editAction();
                      else
                        widget.deleteAction();
                    },
                    icon: Icon(LineIcons.horizontalEllipsis),
                    underline: Container(),
                    items: <String>['Edit', 'Delete']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 1.5),
                        ),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: widget.onTap,
              child: Container(
                height: SizeConfig.safeBlockVertical * 12,
                padding: EdgeInsets.all(8),
                child: _buildPhoneContent(),
              ),
            ),
    );
  }

  Widget _buildPhoneContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
          child: mainTextWidget(textAlign: TextAlign.left),
        ),
        Expanded(child: Container()),
        VerticalDivider(),
        secondaryTextWidget(
          padding: EdgeInsets.only(
            right: SizeConfig.blockSizeHorizontal * 4,
            left: SizeConfig.blockSizeHorizontal * 2,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        mainTextWidget(textAlign: TextAlign.center),
        Expanded(child: Container()),
        Divider(),
        Expanded(child: Container()),
        secondaryTextWidget(),
        Expanded(child: Container()),
      ],
    );
  }

  Widget mainTextWidget({TextAlign textAlign}) {
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Container(
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: '${widget.person.name}\n',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.blockSizeVertical * 3,
          ),
          children: [
            TextSpan(
              text: "Upcoming: $mostRescentEvent",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Nunito-Sans',
                fontWeight: FontWeight.w300,
                fontSize: is700Wide
                    ? SizeConfig.safeBlockVertical * 1.8
                    : SizeConfig.safeBlockVertical * 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget secondaryTextWidget({EdgeInsets padding}) => Container(
        padding: padding,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$remainingDays\n',
            style: TextStyle(
              color: remainingDaysColor,
              fontSize: SizeConfig.blockSizeVertical * 3,
            ),
            children: [
              TextSpan(
                text: daysText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.safeBlockVertical * 2,
                ),
              ),
            ],
          ),
        ),
      );
}
