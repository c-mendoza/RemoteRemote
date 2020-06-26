
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:osc_remote/constants.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final Color color;
  final num fontSize;
  final num letterSpacing;
  final VoidCallback onPressed;

  const StyledButton(
    {Key key,
      this.text,
      this.color,
      this.fontSize = 20.0,
      this.letterSpacing = 1.0,
      this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: onPressed,
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.fromLTRB(8, fontSize / 1, 8, fontSize / 1),
        child: FittedBox(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: text,
                style: kTitleTextStyle.copyWith(
                  fontSize: fontSize,
                  letterSpacing: letterSpacing,
                ),
              )
            ])),
        ),
        color: Theme.of(context).buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7))),
      ),
    );
  }
}