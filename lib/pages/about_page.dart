import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: MarkdownView(markdownFilePath: 'assets/about.md',),
    ));
  }
}

class MarkdownView extends StatefulWidget {

  /// The markdown file in the root bundle
  final String markdownFilePath;
  final String additionalText;
  final MarkdownStyleSheet styleSheet;

  const MarkdownView({Key key, this.markdownFilePath, this.additionalText, this.styleSheet}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MarkdownViewState();
  }
}

class MarkdownViewState extends State<MarkdownView> {
  String _markdownString = "";
  Future<String> _markdownFuture;
  MarkdownStyleSheet _styleSheet;

  void initState() {
    super.initState();
    if (widget.markdownFilePath.length > 0) {
      _markdownFuture = rootBundle.loadString(widget.markdownFilePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.styleSheet == null /*&& _styleSheet == null*/) {
      _styleSheet = _createStyleSheet();
    } else {
      _styleSheet = widget.styleSheet;
    }

    return FutureBuilder(
      future: _markdownFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // The builder triggers when the load initiates but before we have
        // the data, so we have to check if we have the data to use it:
        if (snapshot.data == null) return Container();

        _markdownString = snapshot.data;
        if (widget.additionalText != null) {
          _markdownString += widget.additionalText;
        }
        return Markdown(
          data: _markdownString,
          styleSheet: _styleSheet,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          onTapLink: (text, href, title) => _launchURL(href),
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  MarkdownStyleSheet _createStyleSheet() {
    final kAppThemeData = Theme.of(context);
    return MarkdownStyleSheet(
      a: const TextStyle(color: Colors.blue),
      p: kAppThemeData.textTheme.bodyText1.copyWith(
        height: 1.5,
        fontWeight: FontWeight.w300,
        fontSize: 15,
      ),
      code: kAppThemeData.textTheme.bodyText1.copyWith(
        backgroundColor: kAppThemeData.cardTheme?.color ?? kAppThemeData.cardColor,
        fontFamily: "monospace",
        fontSize: kAppThemeData.textTheme.bodyText1.fontSize * 0.85,
      ),
      h1: TextStyle(
        color: Colors.white,
        fontSize: 36,
        fontFamily: "Roboto",
        letterSpacing: 1,
        fontWeight: FontWeight.w100,
        height: 1,
        decoration: TextDecoration.none),
      h2: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w100,
        height: 1.2,
        decoration: TextDecoration.none),
      h3: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w100,
        height: 1.2,
        decoration: TextDecoration.none),
      h4: kAppThemeData.textTheme.bodyText1,
      h5: kAppThemeData.textTheme.bodyText1,
      h6: kAppThemeData.textTheme.bodyText1,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      del: const TextStyle(decoration: TextDecoration.lineThrough),
      blockquote: kAppThemeData.textTheme.bodyText2,
      img: kAppThemeData.textTheme.bodyText2,
      checkbox: kAppThemeData.textTheme.bodyText2.copyWith(
        color: kAppThemeData.primaryColor,
      ),
      blockSpacing: 25.0,
      listIndent: 24.0,
      listBullet: kAppThemeData.textTheme.bodyText2,
      tableHead: const TextStyle(fontWeight: FontWeight.w600),
      tableBody: kAppThemeData.textTheme.bodyText2,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        color: kAppThemeData.dividerColor,
        width: 1,
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: const BoxDecoration(),
      blockquotePadding: const EdgeInsets.all(8.0),
      blockquoteDecoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(2.0),
      ),
      codeblockPadding: const EdgeInsets.all(8.0),
      codeblockDecoration: BoxDecoration(
        color: kAppThemeData.cardTheme?.color ?? kAppThemeData.cardColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 5.0,
            color: kAppThemeData.dividerColor,
          ),
        ),
      ),
    );
  }
}

