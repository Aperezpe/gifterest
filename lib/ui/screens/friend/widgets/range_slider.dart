import 'package:bonobo/ui/screens/friend/models/friend_page_model.dart';
import 'package:bonobo/ui/style/fontStyle.dart';
import 'package:flutter/material.dart';

class BudgetSlider extends StatelessWidget {
  final FriendPageModel model;
  BudgetSlider({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 15),
          child: Text(
            "Budget",
            style: h3,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${model.startValue}"),
              Expanded(
                child: RangeSlider(
                  values: model.currentRangeValues,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  onChanged: model.updateBudget,
                ),
              ),
              model.endValue == 100
                  ? Text("${model.endValue}+")
                  : Text("${model.endValue}"),
            ],
          ),
        ),
      ],
    );
  }
}
