import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:remote_remote/constants.dart';
import 'package:remote_remote/of_parameter_controller/widgets/editor_app_bar.dart';
import 'package:remote_remote/of_parameter_controller/widgets/server_methods_view.dart';
import 'package:provider/provider.dart';

import '../of_parameter_controller.dart';
import '../types.dart';
import 'of_group_stub.dart';

//final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class OFParameterGroupView extends StatelessWidget {
  final String groupPath;

//  final OFParameterController controller;

  const OFParameterGroupView(this.groupPath);

  @override
  Widget build(BuildContext context) {
    return Consumer<OFParameterController>(
        builder: (context, paramController, __) {
      var group = paramController.getGroupForPath(groupPath);
      var widgets = buildGroupChildren(context, group);
      var color = kDarkOrangeColor.withAlpha(110);
      return Scaffold(
        endDrawer: ServerMethodsView(),
        body: FocusWatcher(
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.25))
            ),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: widgets[index],
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    decoration: BoxDecoration(
                      border: index == 0
                          ? null
                          : Border(top: BorderSide(width: 0.5)),
                    color: index % 2 == 1 ? color : null,
                    ));
                return widgets[index];
              },
              itemCount: widgets.length,
            ),
          ),
        ),
        appBar: EditorAppBar.build(context, group.name),
      );
    });
  }

  List<Widget> buildGroupChildren(
      BuildContext context, OFParameterGroup group) {
    var children = <Widget>[];

    bool isFirst = true;
    for (var child in group.children) {
      children.add(buildParameter(child, context, isFirst));
      isFirst = false;
    }

    return children;
  }

  Widget buildParameter(OFBaseParameter param, BuildContext context,
      [bool? isFirst]) {
    // TODO The container I have here should serve both the GroupStub and the paramWidget
    Widget paramWidget;

    if (param.type == kGroupTypename) {
      paramWidget = OFParameterGroupStub(param.path);
    } else {
      paramWidget = Provider.of<OFParameterController>(context, listen: false)
          .getBuilder(param);
    }

    return paramWidget;
    // var border = Border(
    //   top: BorderSide(width: 0.5),
    // );
    //
    // return Container(
    //     child: paramWidget,
    //     padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
    //     decoration: BoxDecoration(
    //       border: isFirst ? null : border,
    //     ));
  }
}
