import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MailingListWebView extends StatefulWidget {

  @override
  State createState() => MailingListWeb();
}

class MailingListWeb extends State{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: "https://www.srividya.org/email/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

