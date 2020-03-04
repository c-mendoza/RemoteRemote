import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

import 'of_group_view.dart';

class OFParameterGroupStub extends StatelessWidget {
  final OFParameterGroup group;

  const OFParameterGroupStub(this.group, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OFParameterGroupView(group)));
      },
      child: Container(
        padding: kListItemPadding,
        child: Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
                flex: 8,
                child: Text(
                  group.name,
                  style: kLabelStyle,
                )),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                      Icons.navigate_next,
                      size: kLabelStyle.fontSize * 1.6,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
