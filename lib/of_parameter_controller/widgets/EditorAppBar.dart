import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_view.dart';


class EditorAppBar {

  static Widget build(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
//      actions: <Widget>[
//        Align(
//          alignment: Alignment.center,
//          child: Padding(
//            padding: const EdgeInsets.all(6.0),
//            child: IconButton(
//              icon: Icon(
//                Icons.menu,
//                size: 32,
//                color: Theme.of(context).canvasColor,
//              ),
//              onPressed: () {
//                Scaffold.of(context).openEndDrawer();
//              },
//            ),
//          ),
//        )
//      ],
    );
  }
}
