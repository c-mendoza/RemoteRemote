import 'package:flutter/material.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_group_view.dart';

class EditorAppBar {
  static Widget build(BuildContext context, String title) {
    var currentRout = ModalRoute.of(context).settings.name;
    return AppBar(
      title: Text(title),
      leading: (currentRout != null)? IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).textTheme.headline1.color,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          print(ModalRoute.of(context).settings.name);

        },
      ) : null,
      actions: <Widget>[
        // Align(
        //   alignment: Alignment.center,
        //   child: Padding(
        //     padding: const EdgeInsets.all(6.0),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.menu,
        //         size: 32,
        //         color: Theme.of(context).canvasColor,
        //       ),
        //       onPressed: () {
        //         Scaffold.of(context).openEndDrawer();
        //       },
        //     ),
        //   ),
        // )
      ],
    );
  }
}
