import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

class OFNumberParameterWidget extends StatelessWidget {
  final OFParameter param;

  const OFNumberParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NumberEditor(
      label: param.name,
      initialValue: param.value,
      min: param.min,
      max: param.max,
      decimals: param.type == kIntTypename ? 0 : kMaxDecimals,
      onChanged: (val) {
        param.value = val;
      },
    );
  }
}
//  @override
//  State<StatefulWidget> createState() => OFNumberParameterWidgetState();

//}
//
//class OFNumberParameterWidgetState extends State<OFNumberParameterWidget> {
//
//  OFNumberParameterWidgetState() {
//  }
//
//  @override
//  void initState() {
//    _textController = TextEditingController(
//        text: widget.param.type == kIntTypename
//            ? widget.param.value.toString()
//            : formatNumber(widget.param.value));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return null;
//  }
//
//}

class NumberEditor extends StatefulWidget {
  final ValueChanged<num> onChanged;

  /// The number of decimals that the value will display, without affecting
  /// the underlying value. The default is 3.
  /// If set to 0, however, the value will be rounded. Use 0 when you
  /// want to handle integers.
  final int decimals;

  final num initialValue;
  final num min;
  final num max;

  final String label;

  const NumberEditor(
      {Key key,
      this.onChanged,
      this.decimals = 3,
      this.min = 0,
      this.max = 0,
      this.initialValue = 0,
      this.label})
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
                flex: 4,
                child: Text(
                  widget.label,
                  textAlign: TextAlign.left,
                  style: kLabelStyle,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                  textAlign: TextAlign.end,
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
              )
            ],
          ),
        ),
        SliderTheme(
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
        ),
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
    int decimals = widget.decimals;
    var text = val.toStringAsFixed(decimals);

    while (text.length > 6 && decimals > 0) {
      text = val.toStringAsFixed(--decimals);
    }

    return text;
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
