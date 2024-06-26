import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:logging/logging.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:remote_remote/of_parameter_controller/widgets/bool_editor.dart';
import 'package:remote_remote/of_parameter_controller/widgets/color_editor.dart';
import 'package:remote_remote/of_parameter_controller/widgets/number_editor.dart';
import 'package:remote_remote/of_parameter_controller/widgets/point_editor.dart';
import 'package:xml/xml.dart' as xml;

import '../../constants.dart';
import '../of_parameter_controller.dart';
import '../types.dart';
import 'editor_app_bar.dart';

Logger pathLogger = Logger('PathParameter');

class OFPathParameter extends StatefulWidget {
  final OFParameter<String> param;

  const OFPathParameter(this.param, {Key? key}) : super(key: key);

  @override
  _OFPathParameterState createState() => _OFPathParameterState();
}

class _OFPathParameterState extends State<OFPathParameter> {
  List<PathPoint> pathPoints = [];
  late Color pathFillColor;
  late bool pathIsFilled;
  late Color pathStrokeColor;
  late double pathStrokeWidth;

  @override
  void initState() {
    super.initState();
    deserialize();
  }

//
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      deserialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kListItemPadding,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: PathEditor(
                      pathPoints: pathPoints,
                      onChange: (pathPointList) {
                        setState(() {
                          pathPoints =
                              pathPointList; // I think this is redundant
                          serialize();
                        });
                      },
                    ),
                  ),
                  appBar: EditorAppBar.build(context, widget.param.name),
                );
              }));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: Text(
                        widget.param.name,
                        style: kLabelStyle,
                      )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Edit points',
                        style: kActionLabelStyle,
                        textAlign: TextAlign.right,
                      )),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.navigate_next,
                            size: kLabelStyle.fontSize! * 1.5,
                          )))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                NumberEditor(
                  label: 'Stroke Width',
                  value: pathStrokeWidth,
                  min: 0,
                  max: 10,
                  decimals: 2,
                  onChanged: (val) {
                    setState(() {
                      pathStrokeWidth = val.toDouble();
                      serialize();
                    });
                  },
                ),
                ColorEditor(
                  color: pathStrokeColor,
                  label: 'Stroke Color',
                  onChanged: (c) {
                    setState(() {
                      pathStrokeColor = c;
                      serialize();
                    });
                  },
                ),
                BoolEditor(
                  pathIsFilled,
                  label: 'Fill Path',
                  onChanged: (val) {
                    setState(() {
                      pathIsFilled = val;
                      serialize();
                    });
                  },
                ),
                ColorEditor(
                  color: pathFillColor,
                  label: 'Fill Color',
                  onChanged: (c) {
                    setState(() {
                      pathFillColor = c;
                      serialize();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void serialize() {
    var doc = xml.XmlDocument();
    var builder = xml.XmlBuilder();
    builder.element('ofPath', nest: () {
      builder.element('points', nest: () {
        for (var p in pathPoints) {
          builder.element('point', nest: () {
            builder.attribute('type', p.type.index);
            if (p.position != null) {
              builder.attribute('position', offsetToString(p.position!));
            }
            try {
              builder.attribute('cp1', offsetToString(p.cp1!));
              builder.attribute('cp2', offsetToString(p.cp2!));
            } catch (e) {

            }
          });
        }
      });
      builder.element('fill', nest: () {
        builder.attribute(
            'color', OFParameterController.serializeColor(pathFillColor));
        builder.attribute('isFilled', pathIsFilled ? '1' : '0');
      });
      builder.element('stroke', nest: () {
        builder.attribute(
            'color', OFParameterController.serializeColor(pathStrokeColor));
        builder.attribute('strokeWidth', pathStrokeWidth.toString());
      });
    });

    widget.param.value = builder.build().toString();
  }

  String offsetToString(Offset o) {
    return '${o.dx.toStringAsFixed(2)}, ${o.dy.toStringAsFixed(2)}, 0';
  }

  void deserialize() {
//    var commands = widget.param.value.split('{');
    pathPoints.clear();
    xml.XmlDocument doc;
    try {
      doc = xml.parse(widget.param.value);
    } catch (e) {
      pathLogger.severe(
          'Error parsing path xml for the following string:\n ${widget.param.value}');
      return;
    }

    var pointsXml = doc.rootElement.findElements('points').first;

    var pointElements = pointsXml.findElements('point').toList();

    int index = 0;
    // TODO: more error checking in path deserialization
    for (var el in pointElements) {
      var sType = el.getAttribute('type');
      if (sType == null) {
        continue;
      }

      var sPosition = el.getAttribute('position');
      if (sPosition == null) {
        continue;
      }

      var commandTypeIndex = int.parse(sType);
      var commandType = typeForInt(commandTypeIndex);
      var pathPoint = PathPoint(index++, commandType);
      switch (commandType) {
        case PathPointType.moveTo:
        case PathPointType.lineTo:
        case PathPointType.curveTo:
          pathPoint.position = offsetFromString(sPosition);
          pathPoint.cp1 = Offset(0, 0);
          pathPoint.cp2 = Offset(0, 0);
          break;
        case PathPointType.bezierTo:
        case PathPointType.quadBezierTo:
          pathPoint.position = offsetFromString(sPosition);
          pathPoint.cp1 = offsetFromString(el.getAttribute('cp1') ?? sPosition);
          pathPoint.cp2 = offsetFromString(el.getAttribute('cp2') ?? sPosition);
          break;
        case PathPointType.close:
          // Nothing to do for close
          break;
        default:
          pathLogger.warning(
              'Trying to deserialize a Point Type not yet implemented');
          break;
      }

      pathPoints.add(pathPoint);
    }

    var strokeXml = doc.rootElement.findElements('stroke').first;
    var sStrokeColor;
    var sFillColor;
    if (strokeXml.getAttribute('color') != null) {
      sStrokeColor = strokeXml.getAttribute('color');
      pathStrokeColor =
          OFParameterController.deserializeColor(sStrokeColor);
    } else {
      pathStrokeColor = Colors.black;
    }


    pathStrokeWidth = double.parse(strokeXml.getAttribute('strokeWidth') ?? '1');

    var fillXml = doc.rootElement.findElements('fill').first;
    var fillColor = fillXml.getAttribute('color');
    if (fillColor != null) {
      pathFillColor =
          OFParameterController.deserializeColor(fillColor);
    } else {
      pathFillColor = Colors.white;
    }

    pathIsFilled = fillXml.getAttribute('isFilled') == '1';
  }

  PathPointType typeForInt(int type) {
    var types = [
      PathPointType.moveTo,
      PathPointType.lineTo,
      PathPointType.curveTo,
      PathPointType.bezierTo,
      PathPointType.quadBezierTo,
      PathPointType.arc,
      PathPointType.arcNegative,
      PathPointType.close
    ];
    return types[type];
  }

  Offset offsetFromString(String component) {
    var stringCoords = component.split(',');
    bool error = false;
    if (stringCoords.length != 3) {
      pathLogger.severe(
          'Error deserializing point. Did not find three coordinates values. Tried to parse the following:\n$component');
      return Offset(0, 0);
    }

    var x = double.tryParse(stringCoords[0]);
    var y = double.tryParse(stringCoords[1]);

    if (x == null || y == null) {
      pathLogger.severe(
          'Error deserializing point coordinates while trying to parse:\n$component');
      return Offset(0, 0);
    }
    // Ignore z

    return Offset(x, y);
  }
}

class PathEditor extends StatefulWidget {
  final List<PathPoint> pathPoints;
  final ValueChanged<List<PathPoint>> onChange;

  const PathEditor({Key? key, required this.pathPoints, required this.onChange}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FocusWatcher(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: PageView(
                children: buildPointEditors(),
                controller: _pageController,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text('Swipe for additional path points')),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPointEditors() {
    var list = <Widget>[];

    for (var i = 0; i < widget.pathPoints.length; i++) {
      var pathPoint = widget.pathPoints[i];
      if (pathPoint.type == PathPointType.close)
        break; // We don't handle sub paths
      list.add(PathPointEditor(
          pathPoint: pathPoint,
          onChange: (pathPoint) {
            setState(() {
              widget.pathPoints[pathPoint.index] = pathPoint;
              widget.onChange(widget.pathPoints);
            });
          },
          onPointAction: (PointActionType action) {
            switch (action) {
              case PointActionType.addPoint:
                addPathPointAfterIndex(pathPoint.index);
                break;
              case PointActionType.convertPoint:
                convertPathPoint(pathPoint);
                break;
              case PointActionType.deletePoint:
                deletePathPoint(pathPoint);
                break;
            }
          }));
    }
    return list;
  }

  void addPathPointAfterIndex(int index) {
    // If there is a point after this one, which means that there are at least two points and that we are
    // not looking at the end of the path
    if (index + 1 < widget.pathPoints.length) {
      if (widget.pathPoints[index + 1].type != PathPointType.close) {
        var newPoint = PathPoint(index + 1, PathPointType.lineTo);
        newPoint.position = Offset.lerp(widget.pathPoints[index + 1].position,
            widget.pathPoints[index].position, 0.5)!;
        widget.pathPoints.insert(index + 1, newPoint);
      } else {
        var newPoint = PathPoint(index + 1, PathPointType.lineTo);
        newPoint.position = Offset.lerp(widget.pathPoints[index].position,
            widget.pathPoints[0].position, 0.5)!;
        widget.pathPoints.insert(index + 1, newPoint);
      }
    } else {
      // We are adding to the end of the path
      // If that path is closed and we are adding at the end, we need to add the new point
      // prior to the last PathPoint
      if (widget.pathPoints[index].type == PathPointType.close) {
        if (index > 2) {
          // If there are at least three points, lerp between the last non-close
          // point and the first point. Insert point at index-1 to keep the close
          // point at the end.
          var newPoint = PathPoint(index - 1, PathPointType.lineTo);
          newPoint.position = Offset.lerp(widget.pathPoints[index - 1].position,
              widget.pathPoints[0].position, 0.5)!;
          widget.pathPoints.insert(index - 1, newPoint);
        } else {
          var newPoint = PathPoint(index - 1, PathPointType.lineTo);
          newPoint.position = widget.pathPoints[0].position! + Offset(20, 20);
          widget.pathPoints.insert(index - 1, newPoint);
        }
      }
    }

    // Reindex the points:
    _reindexPoints();

    setState(() {
      widget.onChange(widget.pathPoints);
    });
  }

  void _reindexPoints() {
    for (int i = 0; i < widget.pathPoints.length; i++) {
      widget.pathPoints[i].index = i;
    }
  }

  void convertPathPoint(PathPoint pathPoint) {
//    if (pathPoint.type == PathPointType.lineTo) {
//      pathPoint.type = PathPointType.curveTo;
//    } else if (pathPoint.type == PathPointType.curveTo) {
//      pathPoint.type = PathPointType.bezierTo;
//    } else if (pathPoint.type == PathPointType.bezierTo) {
//      pathPoint.type = PathPointType.lineTo;
//    }
    setState(() {
      widget.onChange(widget.pathPoints);
    });
  }

  void deletePathPoint(PathPoint pathPoint) {
    // Basic rules: If we delete the first point, the second point must change to moveTo
    // Don't delete close points
    // Don't delete all points?
    if (widget.pathPoints.length < 2) {
      pathLogger.warning('Can\'t delete last point');
      return;
    }

    if (pathPoint.index == 0 && pathPoint.type == PathPointType.moveTo) {
      widget.pathPoints.removeAt(0);
      widget.pathPoints[0].type = PathPointType.moveTo;
    } else {
      widget.pathPoints.removeAt(pathPoint.index);
    }

    _reindexPoints();
    setState(() {
      widget.onChange(widget.pathPoints);
    });
  }
}

class PathPointEditor extends StatelessWidget {
  final PathPoint pathPoint;
  final ValueChanged<PathPoint> onChange;
  final ValueChanged<PointActionType> onPointAction;

  const PathPointEditor(
      {Key? key, required this.pathPoint, required this.onChange, required this.onPointAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
//                      color: Colors.orange,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Point ${pathPoint.index}',
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Add point',
                            style: kButtonStyle,
                          ),
                          onPressed: () {
                            onPointAction(PointActionType.addPoint);
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Delete point',
                            style: kButtonStyle,
                          ),
                          onPressed: () {
                            onPointAction(PointActionType.deletePoint);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Align(
                          alignment: Alignment.center,
                          child: buildPointEditorOption())),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPointEditorOption() {
    var columnChildren = <Widget>[];

    columnChildren.add(Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Point type'),
        ),
        Expanded(
          flex: 1,
          child: pathPoint.type != PathPointType.moveTo
              ? PopupMenuButton(
                  onSelected: (sel) {
                    switch (sel) {
                      case 0: //Add
                        _setPointType(pathPoint, PathPointType.lineTo);
                        break;
                      case 1: // Convert
                        _setPointType(pathPoint, PathPointType.curveTo);
                        break;
                      case 2:
                        _setPointType(pathPoint, PathPointType.bezierTo);
                        break;
                    }
                  },
//            offset: Offset(-10, -150),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(kBorderRadius))),
                  child: Text(
                    _pointTypeString(pathPoint),
                    style: kButtonStyle,
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Line'),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Curve'),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Bezier'),
                      ),
                    ),
                  ],
                )
              : Text(
                  _pointTypeString(pathPoint),
                  style: kLabelStyle,
                ),
        )
      ],
    ));

    var positionPointEditor = PointEditor(
      point: pathPoint.position!,
      label: 'Position',
      onChange: (offset) {
        pathPoint.position = offset;
        onChange(pathPoint);
      },
    );

    if (pathPoint.type == PathPointType.bezierTo ||
        pathPoint.type == PathPointType.quadBezierTo) {
      var pointEditors = <Widget>[];
      pointEditors.add(positionPointEditor);
      pointEditors.add(PointEditor(
        point: pathPoint.cp1!,
        label: 'Control Point 1',
        onChange: (offset) {
          pathPoint.cp1 = offset;
          onChange(pathPoint);
        },
      ));
      pointEditors.add(PointEditor(
        point: pathPoint.cp2!,
        label: 'Control Point 2',
        onChange: (offset) {
          pathPoint.cp2 = offset;
          onChange(pathPoint);
        },
      ));

      columnChildren.add(
        Container(
          height: 300,
          child: PageIndicatorContainer(
            child: PageView(children: pointEditors),
            length: pointEditors.length,
            indicatorColor: Colors.grey.shade200,
          ),
        ),
      );
      columnChildren.add(Text('Swipe for control points'));
    } else {
      columnChildren.add(Container(child: positionPointEditor));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: columnChildren,
    );
  }

  Widget buildConvertOption() {
    switch (pathPoint.type) {
      case PathPointType.moveTo:
      case PathPointType.arc:
      case PathPointType.arcNegative:
      case PathPointType.close:
        return Container();
      case PathPointType.lineTo:
        return TextButton(
          child: Text(
            'Convert to curve point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.curveTo:
        return TextButton(
          child: Text(
            'Convert to bezier point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.bezierTo:
        return TextButton(
          child: Text(
            'Convert to quad bezier point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.quadBezierTo:
        return TextButton(
          child: Text(
            'Convert to line point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
    }
    return Container();
  }

  String _pointTypeString(PathPoint pathPoint) {
    switch (pathPoint.type) {
      case PathPointType.moveTo:
        return 'Move';
        break;
      case PathPointType.lineTo:
        return 'Line';
        break;
      case PathPointType.curveTo:
        return 'Curve';
        break;
      case PathPointType.bezierTo:
        return 'Bezier';
        break;
      case PathPointType.quadBezierTo:
        return 'Quad Bezier';
        break;
      case PathPointType.arc:
        return 'Arc';
        break;
      case PathPointType.arcNegative:
        return 'Arc Negative';
        break;
      case PathPointType.close:
        return 'Close';
        break;
    }
    return 'SLAAAY QUEEN';
  }

  void _setPointType(PathPoint pathPoint, PathPointType type) {
    pathPoint.type = type;
    onPointAction(PointActionType.convertPoint);
  }
}

enum PointActionType {
  addPoint,
  convertPoint,
  deletePoint,
}

enum PathPointType {
  moveTo,
  lineTo,
  curveTo,
  bezierTo,
  quadBezierTo, // Not implemented
  arc, // Not implemented
  arcNegative, // Not implemented
  close
}

class PathPoint {
  Offset? position;
  Offset? cp1;
  Offset? cp2;
  PathPointType type;
  int index;

  PathPoint(this.index, this.type);
}
