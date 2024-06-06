import 'package:flutter/material.dart';

const kLargeButtonTextStyle =
    TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900);

const kLabelStyle = TextStyle(
  fontSize: 18.0,
  //  color: Color(0xFF8D8E98),
);

const kButtonStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white);

const kActionLabelStyle = TextStyle(
  fontSize: 14.0,
//  color: // Should be the accent color
);

const kSubLabelTextStyle = TextStyle(
  fontSize: 14.0,
);

const kBorderRadius = 8.0;
const kMaxDecimals = 3;

const kPointEditorPadSize = Size(80.0, 80.0);

const kPointEditorIconSize = 80.0;
const kPointEditorPadding = 70.0;

const kListItemPadding = EdgeInsets.fromLTRB(0, 10, 0, 10);

final TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontFamily: "Roboto",
  letterSpacing: 8,
  fontWeight: FontWeight.bold,
  height: 1,
  decoration: TextDecoration.none,
);

final TextStyle kSubTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontFamily: "Roboto",
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
  height: 1,
  decoration: TextDecoration.none,
);

final TextStyle kSubTitle2TextStyle =
    kSubLabelTextStyle.copyWith(fontSize: 23, fontWeight: FontWeight.w100);
final GlobalKey<NavigatorState> kParamNavigatorKey =
    GlobalKey<NavigatorState>();

const kPrefLastServerAddressKey = 'LastHostAddress';
const kPrefNetInterfaceKey = 'NetworkInterfaceName';
final String kDebugIp = '192.168.0.1';

Color kDarkOrangeColor = Color.fromARGB(255, 71, 64, 61);
Color kLightOrangeColor = Color.fromARGB(255, 196, 115, 24);