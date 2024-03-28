import 'package:flutter/material.dart';

import '../types.dart';

class OFStringParameter extends StatefulWidget {
  final OFParameter param;

  const OFStringParameter(this.param, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFStringParameterState();
}

class OFStringParameterState extends State<OFStringParameter> {
  late TextEditingController _textController;

  OFStringParameterState();

  @override
  void initState() {
    super.initState();
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
