import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

class OFColorParameterWidget extends StatefulWidget {
  final OFParameter<Color> param;

  const OFColorParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFColorParameterWidgetState();
}

class OFColorParameterWidgetState extends State<OFColorParameterWidget> {
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
                  widget.param.name,
                  textAlign: TextAlign.left,
                  style: kLabelStyle,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      width: 10,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.param.value,
                        borderRadius:
                            BorderRadius.all(Radius.circular(kBorderRadius)),
                        border: Border.all(
                            color: Color.fromRGBO(200, 200, 200, 1.0),
                            width: 1.5,
                            style: BorderStyle.solid),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            side: BorderSide(
                              color: Colors.grey.shade700,
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          title: Text('${widget.param.name}'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
//                              paletteType: PaletteType.rgb,
                              pickerColor: widget.param.value,
                              onColorChanged: (c) {
                                widget.param.value = c;
                              },
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                            // Use Material color picker:
                            //
                            // child: MaterialPicker(
                            //   pickerColor: pickerColor,
                            //   onColorChanged: changeColor,
                            //   showLabel: true, // only on portrait mode
                            // ),
                            //
                            // Use Block color picker:
                            //
                            // child: BlockPicker(
                            //   pickerColor: currentColor,
                            //   onColorChanged: changeColor,
                            // ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('Done'),
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
