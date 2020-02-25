import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';

import '../types.dart';

class OFStringParameter extends StatefulWidget {
  final OFParameter param;

  const OFStringParameter(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFStringParameterState();
}

class OFStringParameterState extends State<OFStringParameter> {
  TextEditingController _textController;

  OFStringParameterState() {

  }

  @override
  void initState() {
    _textController =
      TextEditingController(text: widget.param.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.param.name),
        Container(
          child: TextField(
            controller: _textController,
            onChanged: (String v) {
              setState(() {
                widget.param.value = v;
              });
            },
          ),
        )
      ],
    );
  }
}
