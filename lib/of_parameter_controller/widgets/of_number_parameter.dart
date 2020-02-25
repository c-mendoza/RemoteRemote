import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

class OFNumberParameterWidget extends StatefulWidget {
  final OFParameter param;

  const OFNumberParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFNumberParameterWidgetState();
}

class OFNumberParameterWidgetState extends State<OFNumberParameterWidget> {
  TextEditingController _textController;

  OFNumberParameterWidgetState() {
//    _textController = TextEditingController(text: widget.param.value.toString());
  }

  @override
  void initState() {
    _textController = TextEditingController(
        text: widget.param.type == OFParameterType.integer
            ? widget.param.value.toString()
            : formatNumber(widget.param.value));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
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
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.end,
                    style: kLabelStyle,
                    controller: _textController,
                    onEditingComplete: () {
                      setState(() {
                        var val = double.tryParse(_textController.text);
                        if (val != null) updateParam(val);
                        FocusScope.of(context).unfocus();
                      });
                    },
                    //                  onChanged: (String v) {
                    //                    setState(() {
                    //                      var val = double.tryParse(v);
                    //                      if (val != null) updateParam(val);
                    //                    });
                    //                  },
                  ))
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
//                    trackShape: CustomTrackShape(),
              ),
          child: Slider(
            value: widget.param.value.toDouble(),
            max: widget.param.max.toDouble(),
            min: widget.param.min.toDouble(),
            onChanged: (double val) {
              setState(() {
                updateParam(val);
              });
            },
          ),
        ),
      ],
    );
  }

  void updateParam(double val) {
    //TODO the param value needs to be clamped to min max here
    //otherwise editing the text field might crash the UI
    val = val.clamp(widget.param.min, widget.param.max);
    if (widget.param.type == OFParameterType.integer) {
      widget.param.value = val.round();
      _textController.text = widget.param.value.toString();
    } else {
      widget.param.value = val;
      _textController.text = formatNumber(val);
    }
  }

  String formatNumber(double val) {
    int decimals = kMaxDecimals;
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
