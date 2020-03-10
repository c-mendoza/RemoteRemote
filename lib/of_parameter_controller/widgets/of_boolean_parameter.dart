import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

import 'bool_editor.dart';

//This should be stateless
class OFBooleanParameterWidget extends StatelessWidget {
  final OFParameter<bool> param;

  const OFBooleanParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoolEditor(
      param.value,
      label: param.name,
      onChanged: (val) {
        param.value = val;
      },
    );
  }
}
