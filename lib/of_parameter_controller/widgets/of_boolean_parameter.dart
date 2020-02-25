import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

class OFBooleanParameterWidget extends StatefulWidget {
  final OFParameter<bool> param;

  const OFBooleanParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFBooleanParameterWidgetState();
}

class OFBooleanParameterWidgetState extends State<OFBooleanParameterWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  widget.param.name,
                  textAlign: TextAlign.left,
                  style: kLabelStyle,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Switch(
                    value: widget.param.value,
                    onChanged: (val) {
                      setState(() {
                        widget.param.value = val;
                      });
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
