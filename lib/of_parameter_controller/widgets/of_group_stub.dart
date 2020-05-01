import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:provider/provider.dart';

import 'of_group_view.dart';

class OFParameterGroupStub extends StatefulWidget {
  final String groupPath;

  const OFParameterGroupStub(this.groupPath, {Key key}) : super(key: key);

  @override
  _OFParameterGroupStubState createState() => _OFParameterGroupStubState();
}

class _OFParameterGroupStubState extends State<OFParameterGroupStub> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    var group = Provider.of<OFParameterController>(context, listen: false)
        .getGroupForPath(widget.groupPath);
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTap: () {
        setState(() {
          isPressed = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OFParameterGroupView(widget.groupPath)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kListItemPadding.vertical),
        color: isPressed ? Theme.of(context).highlightColor : null,
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
