import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/screens/my_friends/models/set_friend_model.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/date_picker.dart';
import 'package:flutter/material.dart';

class AddEventCard extends StatefulWidget {
  AddEventCard({
    @required this.events,
    @required this.model,
    @required this.specialEvent,
  });
  final List<Event> events;
  final SetFriendModel model;
  final SpecialEvent specialEvent;

  @override
  _AddEventCardState createState() => _AddEventCardState();
}

class _AddEventCardState extends State<AddEventCard> {
  int _eventDropdownValue = 0;
  DateTime _specialDate;
  bool _isConcurrent = false;

  SetFriendModel get _model => widget.model;
  SpecialEvent get _specialEvent => widget.specialEvent;

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
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 0, 8.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Container(
              child: _buildEventDropdown(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: DatePicker(
                    labelText: 'Special Date',
                    selectedDate: _specialDate,
                    selectDate: (date) {
                      setState(() => _specialDate = date);
                      _model.updateSpecialEventDate(_specialEvent.id, date);
                    },
                  ),
                ),
                SizedBox(width: 15.0),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Concurrent",
                      style: TextStyle(fontSize: 16.0),
                    ),
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
