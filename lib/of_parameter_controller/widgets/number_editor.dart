import 'package:flutter/material.dart';

import '../../constants.dart';

class NumberEditor extends StatefulWidget {
  final ValueChanged<num> onChanged;

  /// The number of decimals that the value will display, without affecting
  /// the underlying value. The default is 3.
  /// If set to 0, however, the value will be rounded. Use 0 when you
  /// want to handle integers.
  final int decimals;
  final bool showSlider;

  final num initialValue;
  final num min;
  final num max;
  final int labelFlex;
  final int numberFlex;
  final TextAlign labelAlignment;
  final TextAlign numberAlignment;

  final String label;

  const NumberEditor(
      {Key key,
      this.onChanged,
      this.decimals = 3,
      this.min = 0,
      this.max = 0,
      this.initialValue = 0,
      this.label,
      this.showSlider = true,
      this.labelFlex = 3,
      this.numberFlex = 1,
      this.labelAlignment = TextAlign.left,
      this.numberAlignment = TextAlign.end})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NumberEditorState();
  }
}

class NumberEditorState extends State<NumberEditor> {
  double value;
  TextEditingController _textController;

  @override
  void initState() {
    value = widget.initialValue.toDouble();
    _textController = TextEditingController(text: formatNumber(value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: widget.labelFlex,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    widget.label,
                    textAlign: widget.labelAlignment,
                    style: kLabelStyle,
                  ),
                ),
              ),
              Expanded(
                flex: widget.numberFlex,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: widget.decimals > 0, signed: widget.min < 0),
                    onTap: () {
                      _textController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _textController.text.length);
                    },
                    textAlign: widget.numberAlignment,
                    style: kLabelStyle,
                    controller: _textController,
                    onEditingComplete: () {
                      setState(() {
                        var val = double.tryParse(_textController.text);
                        if (val != null) updateValue(val);
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        sliderOption(),
      ],
    );
  }

  void updateValue(double val) {
    //The param value needs to be clamped to min max here
    //otherwise editing the text field might crash the UI
    val = val.clamp(widget.min, widget.max);
    if (widget.decimals == 0) {
      value = val.round().toDouble();
      _textController.text = value.toStringAsFixed(0);
      widget.onChanged(value.toInt());
    } else {
      value = val;
      _textController.text = formatNumber(val);
      widget.onChanged(value);
    }
  }

  String formatNumber(num val) {
    /// For future reference: [TextInputFormatter]
    int decimals = widget.decimals;
    var text = val.toStringAsFixed(decimals);

    while (text.length > 6 && decimals > 0) {
      text = val.toStringAsFixed(--decimals);
    }

    return text;
  }

  Widget sliderOption() {
    if (widget.showSlider) {
      return SliderTheme(
        data: SliderTheme.of(context).copyWith(),
        child: Slider(
          value: value,
          max: widget.max.toDouble(),
          min: widget.min.toDouble(),
          onChanged: (double val) {
            setState(() {
              updateValue(val);
            });
          },
        ),
      );
    } else {
      return Container();
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
