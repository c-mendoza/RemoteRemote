import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../constants.dart';

class ColorEditor extends StatefulWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const ColorEditor(
      {Key? key, required this.label, required this.color, required this.onChanged})
      : super(key: key);

  @override
  _ColorEditorState createState() => _ColorEditorState();
}

class _ColorEditorState extends State<ColorEditor> {
  // late Color color;

  @override
  void initState() {
    // color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: GestureDetector(
                child: Container(
                  width: 10,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.color,
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
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          side: BorderSide(
                            color: Colors.grey.shade700,
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        title: Text('${widget.label}'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
//                              paletteType: PaletteType.rgb,
                            pickerColor: widget.color,
                            onColorChanged: (c) {
                              setState(() {
                                widget.onChanged(c);
                              });
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
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}
