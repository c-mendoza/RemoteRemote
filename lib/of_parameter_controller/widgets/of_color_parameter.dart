import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:osc_remote/of_parameter_controller/widgets/color_editor.dart';

class OFColorParameterWidget extends StatefulWidget {
  final OFParameter<Color> param;

  const OFColorParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFColorParameterWidgetState();
}

class OFColorParameterWidgetState extends State<OFColorParameterWidget> {
  @override
  Widget build(BuildContext context) {
    return ColorEditor(
      color: widget.param.value,
      label: widget.param.name,
      onChanged: (c) {
        setState(() {
          widget.param.value = c;
        });
      },
    );
  }
}
