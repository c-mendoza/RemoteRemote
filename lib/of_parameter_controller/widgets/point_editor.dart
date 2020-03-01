import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/widgets/number_editor.dart';

import '../../constants.dart';

class PointEditor extends StatefulWidget {
  final Offset point;
  final ValueChanged<Offset> onChange;

  const PointEditor({Key key, @required this.point, @required this.onChange})
      : super(key: key);

  @override
  _PointEditorState createState() => _PointEditorState();
}

class _PointEditorState extends State<PointEditor>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Offset _point;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _point = widget.point;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: buildButtonStack(context)),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NumberEditor(
                label: 'X',
                initialValue: _point.dx,
                showSlider: false,
                decimals: 0,
                labelFlex: 1,
                numberFlex: 1,
                labelAlignment: TextAlign.right,
                numberAlignment: TextAlign.left,
                onChanged: (val) {
                  setState(() {
                    widget.onChange(Offset(val, _point.dy));
                  });
                },
              ),
              NumberEditor(
                label: 'Y',
                initialValue: _point.dx,
                showSlider: false,
                decimals: 0,
                labelFlex: 1,
                numberFlex: 1,
                labelAlignment: TextAlign.right,
                numberAlignment: TextAlign.left,
                onChanged: (val) {
                  setState(() {
                    widget.onChange(Offset(val, _point.dy));
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtonStack(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        Positioned(
          top: -kPointEditorIconSize.height / 4,
          left: (kPointEditorPadSize.width / 2) +
              kPointEditorPadding -
              (kPointEditorIconSize.width / 2),
          child: ArrowButton(
              direction: Direction.up,
              onTap: () {
                widget.onChange(widget.point.translate(0, 1));
              }),
        ),
        Positioned(
          top: kPointEditorPadding +
              (kPointEditorPadSize.height / 2) -
              (kPointEditorIconSize.height / 2),
          left: kPointEditorPadding +
              kPointEditorPadSize.width -
              kPointEditorIconSize.width / 4,
          child: ArrowButton(
              direction: Direction.right,
              onTap: () {
                widget.onChange(widget.point.translate(1, 0));
              }),
        ),
        Positioned(
          bottom: -kPointEditorIconSize.height / 4,
          left: (kPointEditorPadding +
              kPointEditorPadSize.width / 2 -
              (kPointEditorIconSize.width / 2)),
          child: ArrowButton(
              direction: Direction.down,
              onTap: () {
                widget.onChange(widget.point.translate(0, -1));
              }),
        ),
        Positioned(
          top: kPointEditorPadding +
              (kPointEditorPadSize.height / 2) -
              (kPointEditorIconSize.height / 2),
          left: -kPointEditorIconSize.width / 4,
          child: ArrowButton(
              direction: Direction.left,
              onTap: () {
                widget.onChange(widget.point.translate(-1, 0));
              }),
        ),
        Container(
          padding: EdgeInsets.all(kPointEditorPadding),
          child: CenterPad(
            width: kPointEditorPadSize.width,
            height: kPointEditorPadSize.height,
            color: Theme.of(context).accentColor,
            onDrag: (offset) {
              setState(() {
                _point += offset;
                widget.onChange(_point);
              });
            },
          ),
        ),
      ]),
    );
  }
}

enum Direction {
  right,
  down,
  left,
  up,
}

class ArrowButton extends StatefulWidget {
  final Direction direction;
  final Function onTap;
  final double iconSize;

  const ArrowButton({
    Key key,
    @required this.direction,
    @required this.onTap,
    this.iconSize = 80.0,
  }) : super(key: key);

  @override
  _ArrowButtonState createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (e) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (e) {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: RotatedBox(
        quarterTurns: widget.direction.index,
        child: Icon(
          Icons.chevron_right,
          color: _isPressed
              ? Theme.of(context).highlightColor
              : Theme.of(context).accentColor,
          size: widget.iconSize,
        ),
      ),
    );
  }
}

class CenterPad extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final ValueChanged<Offset> onDrag;

  const CenterPad(
      {Key key,
      this.width,
      this.height,
      this.color = Colors.black,
      this.onDrag})
      : super(key: key);

  @override
  _CenterPadState createState() => _CenterPadState();
}

class _CenterPadState extends State<CenterPad> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        print(e);
      },
      onPointerMove: (e) {
        print('${e.delta} ${e.distance}');
        widget.onDrag(e.delta);
      },
      child: GestureDetector(
        onTapDown: (dets) {
          print('taaaapped down');
        },
        onTap: () {
          print('TAPPED CENTER PAD');
        },
        onPanStart: (details) {
          // Because of the ListView does not inhibit its verticalDrag gesture
          // we can't just use Pan gestures. Instead, we use the 'raw' Listeners.
          // We are specifying the Pan gestures to signal that we are indeed interested in them.
        },
        onPanUpdate: (details) {
//          print(details);
        },
        onPanEnd: (details) {},
        onVerticalDragStart: (details) {
          // The vertical drags need to be specified to inhibit the ListView's
          // vertical gesture
        },
        onVerticalDragUpdate: (details) {
          // The vertical drags need to be specified to inhibit the ListView's
          // vertical gesture
        },
        child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: widget.color, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
            )),
      ),
    );
  }
}
