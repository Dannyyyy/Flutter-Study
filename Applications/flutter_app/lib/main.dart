import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/first_tab.dart';
import 'package:flutter_app/tabs/second_tab.dart';
import 'package:flutter_app/tabs/third_tab.dart';
import 'package:flutter_app/pages/info_page.dart';
import 'package:flutter_app/pages/settings_page.dart';
import 'package:flutter_app/pages/stock_page.dart';
import 'package:flutter_app/pages/isolate_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/pages/scoped_page.dart';
import 'package:flutter_app/pages/jokes_page.dart';
import 'package:flutter_app/pages/add_contact_page.dart';
import 'package:flutter_app/pages/auto_page.dart';

List<CameraDescription> cameras = new List<CameraDescription>();

Future<void> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(App());
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
  }


  void navInfo(BuildContext context) {
    Navigator.of(context).pushNamed('/info');
  }

  void navSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }

  void navStocks(BuildContext context) {
    Navigator.of(context).pushNamed('/stocks');
  }

  void navIsolate(BuildContext context) {
    Navigator.of(context).pushNamed('/isolate');
  }

  void navScoped(BuildContext context) {
    Navigator.of(context).pushNamed('/scoped');
  }

  void navJokes(BuildContext context) {
    Navigator.of(context).pushNamed('/jokes');
  }

  void navAuto(BuildContext context) {
    Navigator.of(context).pushNamed('/auto');
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Builder(builder: (context) =>
      Scaffold(
        key: _scaffoldKey,
          appBar: new AppBar(
            leading: new Icon(Icons.menu),
            title: new Text("App"),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.info),
                onPressed: () => navInfo(context),
              ),
              new IconButton(
                icon: new Icon(Icons.settings),
                onPressed: () => navSettings(context)
              )
            ],
          ),
          body: new TabBarView(
            // Add tabs as widgets
            children: <Widget>[
              new FirstTab(_scaffoldKey), new SecondTab(), new CameraExampleHome(cameras: cameras)],
            // set the controller
            controller: controller,
          ),
          drawer: new Drawer(
            child: new ListView(
              children: [
                new ListTile(
                  title: new Text("Menu"),
                ),
                new Divider(),
                new ListTile(
                  title: new Text("Stocks(Refresh, Dismissible)"),
                  trailing: new Icon(Icons.card_travel),
                  onTap: () {
                    Navigator.of(context).pop();
                    navStocks(context);
                  }),
                new ListTile(
                  title: new Text("Isolate"),
                  trailing: new Icon(Icons.filter_tilt_shift),
                  onTap: () {
                    Navigator.of(context).pop();
                    navIsolate(context);
                  }),
                new ListTile(
                  title: new Text("Scoped Model"),
                  trailing: new Icon(Icons.card_travel),
                  onTap: () {
                    Navigator.of(context).pop();
                    navScoped(context);
                  }),
                new ListTile(
                  title: new Text("Jokes(Online)"),
                  trailing: new Icon(Icons.thumbs_up_down),
                  onTap: () {
                    Navigator.of(context).pop();
                    navJokes(context);
                  }),
                new ListTile(
                    title: new Text("Auto(Firebase)"),
                    trailing: new Icon(Icons.directions_car),
                    onTap: () {
                      Navigator.of(context).pop();
                      navAuto(context);
                    }),
              ],
            ),
          ),
          bottomNavigationBar: new Material(
            // set the color of the bottom navigation bar
            color: Colors.blue,
            // set the tab bar as the child of bottom navigation bar
            child: new TabBar(
              tabs: <Tab>[
                new Tab(
                  icon: new Icon(Icons.favorite),
                ),
                new Tab(
                  icon: new Icon(Icons.contacts),
                ),
                new Tab(
                  icon: new Icon(Icons.photo_camera),
                ),
              ],
              controller: controller,
            ),
          )
      )
    );
  }
}

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new HomePage(),
        '/info': (BuildContext context) => new InfoPage(),
        '/settings': (BuildContext context) => new SettingsPage(),
        '/stocks': (BuildContext context)  => new StockPage(),
        '/isolate': (BuildContext context)  => new IsolatePage(),
        '/scoped': (BuildContext context) => new ScopedPage(),
        '/jokes': (BuildContext context) => new JokesPage(),
        '/contact': (BuildContext context) => new ContactPage(),
        '/auto': (BuildContext context) => new AutoPage(),
      },
    );
  }
}
