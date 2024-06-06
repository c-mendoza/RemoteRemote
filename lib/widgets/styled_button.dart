
import 'package:flutter/material.dart';
import 'package:remote_remote/constants.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final Color color;
  final num fontSize;
  final num letterSpacing;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const StyledButton(
    { Key? key,
      required this.text,
      required this.color,
      this.fontSize = 20.0,
      this.letterSpacing = 1.0,
      required this.onPressed,
      this.padding = const EdgeInsets.all(8.0)})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        // padding: EdgeInsets.fromLTRB(8, fontSize / 1, 8, fontSize / 1),
        child: FittedBox(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: text,
                style: kButtonTextStyle.copyWith(
                  fontSize: fontSize.toDouble(),
                  letterSpacing: letterSpacing.toDouble(),
                ),
              )
            ])),
        ),
        // color: Theme.of(context).primaryColor,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(7))),
      ),
    );
  }
}
