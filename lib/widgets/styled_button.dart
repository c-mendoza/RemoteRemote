
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_remote/constants.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final Color color;
  final num fontSize;
  final num letterSpacing;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const StyledButton(
    {Key key,
      this.text,
      this.color,
      this.fontSize = 20.0,
      this.letterSpacing = 1.0,
      this.onPressed,
      this.padding = const EdgeInsets.all(8.0)})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
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
                style: kButtonTextStyle.copyWith(
                  fontSize: fontSize,
                  letterSpacing: letterSpacing,
                ),
              )
            ])),
        ),
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7))),
      ),
    );
  }
}
