
import 'package:flutter/material.dart';
import 'package:remote_remote/of_parameter_controller/widgets/number_editor.dart';

import '../../constants.dart';

class PointEditor extends StatefulWidget {
  final Offset point;
  final ValueChanged<Offset> onChange;
  final String label;

  const PointEditor(
      {Key? key, required this.point, required this.onChange, this.label = ''})
      : super(key: key);

  @override
  _PointEditorState createState() => _PointEditorState();
}

class _PointEditorState extends State<PointEditor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Offset _point;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _point = widget.point;
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _point = widget.point;
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2, // TODO: On smaller screens, this flex should be 1
              child: Text(widget.label),
            ),
            Expanded(
              flex: 1,
              child: NumberEditor(
                label: 'x:',
                value: _point.dx,
                showSlider: false,
                decimals: 0,
                labelFlex: 1,
                numberFlex: 2,
                labelAlignment: TextAlign.left,
                numberAlignment: TextAlign.left,
                onChanged: (val) {
                  setState(() {
                    _point = Offset(val.toDouble(), _point.dy);
                    widget.onChange(_point);
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: NumberEditor(
                label: 'y:',
                value: _point.dy,
                showSlider: false,
                decimals: 0,
                labelFlex: 1,
                numberFlex: 2,
                labelAlignment: TextAlign.left,
                numberAlignment: TextAlign.left,
                onChanged: (val) {
                  setState(() {
                    _point = Offset(_point.dx, val.toDouble());
                    widget.onChange(_point);
                  });
                },
              ),
            ),
          ],
        ),
        buildButtonStack(context),
      ],
    );
  }

  Widget buildButtonStack(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned(
        bottom: kPointEditorPadSize.height + kPointEditorPadding,
        left: kPointEditorPadding +
            kPointEditorPadSize.width / 2 -
            kPointEditorIconSize / 2,
        child: ArrowButton(
          direction: Direction.up,
          onTap: () {
            setState(() {
              _point = _point.translate(0, -1);
              widget.onChange(_point);
            });
          },
          iconSize: kPointEditorIconSize,
        ),
      ),
      Positioned(
        top: kPointEditorPadding +
            kPointEditorPadSize.height / 2 -
            kPointEditorIconSize / 2,
        left: kPointEditorPadding * 1 + kPointEditorPadSize.width,
        child: ArrowButton(
          direction: Direction.right,
          onTap: () {
            setState(() {
              _point = _point.translate(1, 0);
              widget.onChange(_point);
            });
          },
          iconSize: kPointEditorIconSize,
        ),
      ),
      Positioned(
        top: kPointEditorPadSize.height + kPointEditorPadding,
        left: kPointEditorPadding +
            kPointEditorPadSize.width / 2 -
            kPointEditorIconSize / 2,
        child: ArrowButton(
          direction: Direction.down,
          onTap: () {
            setState(() {
              _point = _point.translate(0, 1);
              widget.onChange(_point);
            });
          },
          iconSize: kPointEditorIconSize,
        ),
      ),
      Positioned(
        top: kPointEditorPadding +
            kPointEditorPadSize.height / 2 -
            kPointEditorIconSize / 2,
        right: kPointEditorPadSize.width + kPointEditorPadding,
        child: ArrowButton(
          direction: Direction.left,
          onTap: () {
            setState(() {
              _point = _point.translate(-1, 0);
              widget.onChange(_point);
            });
          },
          iconSize: kPointEditorIconSize,
        ),
      ),
      Container(
        padding: EdgeInsets.all(kPointEditorPadding),
        child: DragPad(
          width: kPointEditorPadSize.width,
          height: kPointEditorPadSize.height,
          color: Theme.of(context).colorScheme.secondary,
          onDrag: (offset) {
            setState(() {
              offset *= 2.0;
              _point += offset;
              widget.onChange(_point);
            });
          },
        ),
      ),
    ]);
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
    Key? key,
    required this.direction,
    required this.onTap,
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
              : Theme.of(context).colorScheme.secondary,
          size: widget.iconSize,
        ),
      ),
    );
  }
}

enum DragPadMode {
  vertical,
  horizontal,
  both,
}

class DragPad extends StatefulWidget {
  final DragPadMode mode;
  final double width;
  final double height;
  final Color color;
  final ValueChanged<Offset> onDrag;

  const DragPad(
      {Key? key,
      required this.width,
      required this.height,
      this.color = Colors.black,
      required this.onDrag,
      this.mode = DragPadMode.both})
      : super(key: key);

  @override
  _DragPadState createState() => _DragPadState();
}

class _DragPadState extends State<DragPad> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
//        print(e);
      },
      onPointerMove: (e) {
        Offset offset;
        switch (widget.mode) {
          case DragPadMode.vertical:
            offset = Offset(0, e.delta.dy);
            break;
          case DragPadMode.horizontal:
            offset = Offset(e.delta.dx, 0);
            break;
          case DragPadMode.both:
            offset = e.delta;
            break;
        }
        widget.onDrag(offset);
      },
      // Can't specify simultaneous horizontal and vertical detectors, and the
      // pan detector doesn't inhibit dragging in parent widgets. Hence we
      // nest GestureDetectors to capture both horizontal and vertical
      // drags and prevent parents to react to dragging gestures.
      child: GestureDetector(
        onHorizontalDragStart: (_) {},
        child: GestureDetector(
          onTapDown: (dets) {},
          onTap: () {},
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
      ),
    );
  }
}
