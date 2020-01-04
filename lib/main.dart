import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calendar/calendar_event.dart';
import 'volunteer_form/volunteer_form.dart';
import 'mailing_list/services/mailingListAPI.dart';
import 'live_stream/live_stream.dart';
import 'package:flutter/rendering.dart';
import 'colors.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Build a Shrine Theme (103)
final ThemeData _templeTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.yellow[900],
    primaryColor: Colors.redAccent[700],
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Colors.amber[100],
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: templeBackgroundWhite,
    cardColor: templeBackgroundWhite,
    textSelectionColor: templePink100,
    errorColor: templeErrorRed,
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Sri Vidya Temple App',
      theme: _templeTheme,
        //ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //primarySwatch: Colors.red,
      //),
      home: MyHomePage(title: 'Sri Vidya Temple'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    // Container templeInfo = Container(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Text(
    //     "Information about the temple",
    //     textAlign: TextAlign.center,
    //     style: Theme.of(context).textTheme.display1,
    //   )
    // );

    Color color = Theme.of(context).primaryColor;

    Container templeInfo = Container(
      padding: const EdgeInsets.all(4.0),
      child: new GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(4.0),
          children:[
              _buildButtonColumn(color, Icons.call, 'CALL'),
              _buildButtonColumn(color, Icons.pin_drop, 'MAP'),
              _buildButtonColumn(color, Icons.hourglass_full, 'HOURS'),
              _buildButtonColumn(color, Icons.email, 'EMAIL'),
              _buildButtonColumn(color, Icons.view_list, 'SCHEDULE'),
              _buildButtonColumn(color, Icons.card_giftcard, 'SPONSOR'),
              _buildButtonColumn(color, Icons.wc, 'ATTIRE'),
              _buildButtonColumn(color, Icons.language, 'WEBSITE'),
              _buildButtonColumn(color, Icons.local_library, 'FAQ'),
              _buildButtonColumn(color, Icons.live_tv, 'LIVE'),
              _buildButtonColumn(color, Icons.tap_and_play, 'NEWS'),
              _buildButtonColumn(color, Icons.photo_camera, 'INSTAGRAM'),
            ],
          ),
    );

    List<Widget> _children = [
      CalendarEvent(),
      templeInfo,
      MailingListForm(),
      LiveStream(),
      VolunteerForm(),
    ];
    DefaultTabController controller = DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sri Vidya Temple'),
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: _templeTheme.primaryColor,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (int i) {setState((){index = i;});},
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: new Text('Calendar'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: new Text('Temple Info'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: new Text('Mailing List'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.live_tv),
              title: new Text('Live Stream'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.folder_open),
              title: new Text('Volunteer Form'),
            ),
          ]
        )),
        body: Container(
          child: _children[index],
          constraints: BoxConstraints.expand(),
        )
      ),
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return controller;
  }

    GestureDetector _buildButtonColumn(Color color, IconData icon, String label) {
    onTap(){
      if(label == "CALL"){
        launch("tel://5855331970");
      }else if(label == "EMAIL"){
        launch("mailto://info@srividya.org");
      }else if(label == "WEBSITE"){
        launch("https://srividya.org/");
      }else if(label == "MAP"){
        launch("https://maps.apple.com/?sll=42.997884,-77.702095");
      }else if(label == "INSTAGRAM"){
        launch("https://www.instagram.com/srividyatemple/");
      }else if(label == "LIVE"){
        launch("https://livestream.com/accounts/3812069/svts");
      }else if(label == "NEWS"){
        launch("https://srividya.org/category/temple-news/");
      }else if(label == "FAQ"){
        launch("https://srividya.org/faqs/");
      }else if(label == "SCHEDULE"){
        launch("https://srividya.org/visiting-info/daily-puja-schedule/");
      }else if(label == "HOURS"){
        launch("https://srividya.org/visiting-info/temple-hours/");
      }else if(label == "ATTIRE"){
        launch("https://srividya.org/visiting-info/dress-code-etiquette/");
      }else{
        launch("https://bookstore.srividya.org/");
      }
    }
    return GestureDetector(
      onTap: onTap,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    ));
  }
}
