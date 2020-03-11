import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:provider/provider.dart';

import 'of_group_view.dart';

class OFParameterGroupStub extends StatelessWidget {
  final String groupPath;

  const OFParameterGroupStub(this.groupPath, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var group = Provider.of<OFParameterController>(context, listen: false)
        .getGroupForPath(groupPath);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OFParameterGroupView(groupPath)));
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
