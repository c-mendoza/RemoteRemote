import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
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

  void initState() {
    super.initState();
    if (widget.markdownFilePath.length > 0) {
      _markdownFuture = rootBundle.loadString(widget.markdownFilePath);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          styleSheet: widget.styleSheet,
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
}

