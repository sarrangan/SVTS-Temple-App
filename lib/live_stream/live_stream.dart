import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveStream extends StatefulWidget {
  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: WebView(
        initialUrl: 'https://livestream.com/accounts/3812069/events/2376453/player?width=1200&height=1000enableInfoAndActivity=true&defaultDrawer=feed&autoPlay=true&mute=true',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}