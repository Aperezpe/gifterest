import 'package:auto_size_text/auto_size_text.dart';
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
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 1.5,
                            ),
                          ),
                          value: value,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: widget.onTap,
              child: Container(
                height: SizeConfig.safeBlockVertical * 13,
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
          width: SizeConfig.safeBlockHorizontal * 60,
          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
          child: mainTextWidget(alignment: Alignment.centerLeft),
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 2,
          ),
          child: mainTextWidget(alignment: Alignment.center),
        ),
        Expanded(child: Container()),
        Divider(),
        Expanded(child: Container()),
        secondaryTextWidget(),
        Expanded(child: Container()),
      ],
    );
  }

  Widget mainTextWidget({Alignment alignment}) {
    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: alignment == Alignment.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.person.name}',
            softWrap: false,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.titleSize,
            ),
          ),
          Text(
            "Upcoming: $mostRescentEvent",
            softWrap: false,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Nunito-Sans',
              fontWeight: FontWeight.w300,
              fontSize: SizeConfig.subtitleSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget secondaryTextWidget({EdgeInsets padding}) => Container(
        padding: padding,
        child: AutoSizeText.rich(
          TextSpan(
            text: remainingDays <= 999 ? '$remainingDays\n' : '999+\n',
            style: TextStyle(
              color: remainingDaysColor,
              fontSize: SizeConfig.titleSize,
            ),
            children: [
              TextSpan(
                text: daysText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.subtitleSize,
                ),
              ),
            ],
          ),
          stepGranularity: 1,
          maxLines: 2,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
      );
}
