import 'package:flutter/material.dart';

import '../../constants.dart';

class BoolEditor extends StatefulWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const BoolEditor(this.value, {this.label, Key key, this.onChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoolEditorState();
}

class BoolEditorState extends State<BoolEditor> {
  bool value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.label,
                  textAlign: TextAlign.left,
                  style: kLabelStyle,
                  ),
                ),
              Expanded(
                flex: 1,
                child: Switch(
                  value: value,
                  onChanged: (val) {
                    setState(() {
                      value = val;
                      widget.onChanged(val);
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
