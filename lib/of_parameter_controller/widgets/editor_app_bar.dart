import 'package:flutter/material.dart';

class EditorAppBar {
  static AppBar build(BuildContext context, String title) {
    var currentRoute = ModalRoute.of(context)?.settings.name;
    return AppBar(
      title: Text(title),
      leading: (currentRoute != null)? IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          print(ModalRoute.of(context)?.settings.name);

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
