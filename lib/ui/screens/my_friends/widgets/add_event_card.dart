import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/screens/my_friends/models/set_special_event_model.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/date_picker.dart';
import '../../../style/fontStyle.dart';

import 'package:flutter/material.dart';

class AddEventCard extends StatefulWidget {
  AddEventCard({
    @required this.index,
    @required this.events,
    @required this.model,
    @required this.specialEvent,
  });
  final int index;
  final List<Event> events;
  final SetSpecialEventModel model;
  final SpecialEvent specialEvent;

  @override
  _AddEventCardState createState() => _AddEventCardState();
}

class _AddEventCardState extends State<AddEventCard> {
  int _eventDropdownValue = 0;
  DateTime _specialDate;
  bool _isConcurrent = false;

  SetSpecialEventModel get _model => widget.model;
  SpecialEvent get _specialEvent => widget.specialEvent;
  int get eventNumber => widget.index + 1;

  @override
  void initState() {
    super.initState();
    final start = DateTime.now();
    _specialDate =
        _specialEvent.date ?? DateTime(start.year, start.month, start.day);

    //Initialize dropdown event with the given special event, if any.
    for (int i = 0; i < widget.events.length; i++) {
      if (widget.events[i].name == _specialEvent.name) {
        _eventDropdownValue = i;
        break;
      }
    }
    _isConcurrent = _specialEvent?.isConcurrent;
  }

  void _deleteCard() => _model.deleteSpecialEvent(_specialEvent);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 18.0),
          child: Column(
            children: [
              _buildEventDropdown(),
              DatePicker(
                labelText: 'Special Date',
                selectedDate: _specialDate,
                selectDate: (date) {
                  setState(() => _specialDate = date);
                  _model.updateSpecialEventDate(_specialEvent.id, date);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Concurrent", style: p),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 42.0,
                      child: Switch(
                        value: _isConcurrent ?? false,
                        onChanged: (value) {
                          setState(() => _isConcurrent = value);
                          _model.updateSpecialEventConcurrent(
                            _specialEvent.id,
                            value,
                          );
                        },
                        activeColor: Colors.greenAccent,
                        activeTrackColor: Colors.lightGreenAccent[400],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Event $eventNumber",
            style: h3,
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.zero,
            child: IconButton(
              splashRadius: 18,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: _deleteCard,
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton<int> _buildEventDropdown() {
    return DropdownButton(
      isExpanded: true,
      value: _eventDropdownValue,
      items: [
        for (int i = 0; i < widget.events.length; i++)
          DropdownMenuItem(
            child: Text(widget.events[i].name),
            value: i,
          )
      ],
      onChanged: (value) {
        final eventName = widget.events[value].name;
        setState(() {
          _eventDropdownValue = value;
        });
        _model.updateSpecialEventName(_specialEvent.id, eventName);
      },
    );
  }
}
