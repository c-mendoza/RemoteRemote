import 'package:flutter/cupertino.dart';

//enum AppStatus {
//
//}

class AppModel with ChangeNotifier {
  bool _parametersReady = false;

  bool get parametersReady => _parametersReady;

  set parametersReady(bool value) {
    _parametersReady = value;
    notifyListeners();
  }

  bool _connectPressed = false;

  bool get connectPressed => _connectPressed;

  set connectPressed(bool value) {
    _connectPressed = value;
    notifyListeners();
  }
}
