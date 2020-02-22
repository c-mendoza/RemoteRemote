import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';

import '../types.dart';

class OFNumberParameter extends StatefulWidget {
  final OFParameter param;

  const OFNumberParameter(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFNumberParameterState();
}

class OFNumberParameterState extends State<OFNumberParameter> {
  TextEditingController _textController;

  OFNumberParameterState() {
    _textController = TextEditingController(text: widget.param.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Text(widget.param.name),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Slider(
                  value: widget.param.value,
                  max: widget.param.max,
                  min: widget.param.min,
                  onChanged: (double val) {
                    setState(() {
                      updateParam(val);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _textController,
                  onChanged: (String v) {
                    setState(() {
                      var val = double.tryParse(v);
                      if (val != null) updateParam(val);
                    });
                  },
                )
              )
            ],
          ),
        )
      ],
    );
  }

  void updateParam(double val) {
    if (widget.param.type == OFParameterType.integer) {
      widget.param.value = val.round();
    } else {
      widget.param.value = val;
    }
  }
}
