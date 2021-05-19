// import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/ui/common_widgets/platform_dropdown/platform_dropdown.dart';
import 'package:bonobo/ui/common_widgets/platform_switch.dart';
import 'package:bonobo/ui/screens/my_friends/models/set_special_event_model.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/platform_date_picker.dart';

import 'package:flutter/material.dart';

class AddEventCard extends StatefulWidget {
  final int index;
  final List<String> events;
  final SetSpecialEventModel model;
  final SpecialEvent specialEvent;

  const AddEventCard({
    Key key,
    this.index,
    this.events,
    this.model,
    this.specialEvent,
  }) : super(key: key);

  @override
  _AddEventCardState createState() => _AddEventCardState();
}

class _AddEventCardState extends State<AddEventCard> {
  DateTime _specialDate;
  bool _isConcurrent;
  List<String> specialEventValues;

  int get eventNumber => widget.index + 1;

  @override
  void initState() {
    _specialDate = widget.specialEvent.date ?? DateTime.now();

    _isConcurrent = widget.specialEvent.isConcurrent ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    // final is700Wide = SizeConfig.screenWidth >= 700;
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final is700Wide = screenWidth >= 700;
        return Container(
          padding: EdgeInsets.fromLTRB(
            screenWidth / 45,
            screenWidth / 45,
            screenWidth / 45,
            0,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth / 50),
            ),
            elevation: screenWidth / 70,
            child: Column(
              children: [
                _buildHeader(constraints),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 5,
                  ),
                  child: Column(
                    children: [
                      PlatformDropdown(
                        initialValue: widget.specialEvent.name,
                        title: "Choose Event",
                        values: widget.events,
                        onChanged: (value) => {
                          widget.model.updateSpecialEvent(
                            widget.index,
                            name: widget.events[value],
                          )
                        },
                      ),
                      SizedBox(height: 15),
                      PlatformDatePicker(
                        initialDate: widget.specialEvent.date,
                        selectedDate: _specialDate,
                        selectDate: (date) => {
                          setState(() => _specialDate = date),
                          widget.model.updateSpecialEvent(
                            widget.index,
                            date: _specialDate,
                          ),
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: screenWidth / 60,
                          bottom: screenWidth / 60,
                          left: screenWidth / 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Concurrent",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: is700Wide
                                        ? screenWidth * .025
                                        : screenWidth * .04,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                child: Transform.scale(
                                  scale: is700Wide ? 1.2 : .8,
                                  child: PlatformSwitch(
                                    value: _isConcurrent ?? false,
                                    onChanged: (value) => {
                                      setState(() => _isConcurrent = value),
                                      widget.model.updateSpecialEvent(
                                        widget.index,
                                        isConcurrent: _isConcurrent,
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildHeader(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final is700Wide = screenWidth >= 700;
    return Container(
      height: is700Wide ? screenWidth / 15 : screenWidth / 8,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(
        left: is700Wide ? screenWidth / 40 : screenWidth / 20,
        right: screenWidth / 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth / 50),
          topRight: Radius.circular(screenWidth / 50),
        ),
        color: Colors.grey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Event $eventNumber",
            style: TextStyle(
              color: Colors.black,
              fontSize: is700Wide ? screenWidth * .03 : screenWidth * .045,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.zero,
            child: IconButton(
              splashRadius: 18,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: is700Wide ? screenWidth / 30 : screenWidth / 15,
              ),
              onPressed: () => {
                widget.model
                    .deleteSpecialEvent(widget.index, widget.specialEvent),
              },
            ),
          ),
        ],
      ),
    );
  }
}
