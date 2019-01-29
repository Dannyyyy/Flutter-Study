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
import 'package:flutter_app/pages/sign_up_page.dart';
import 'package:flutter_app/pages/sign_in_page.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:flutter_app/redux/reducers/app_reducer.dart';
import 'package:flutter_app/redux/middleware/auth_middleware.dart';
import 'package:redux_logging/redux_logging.dart';

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
  final AuthService _authService = new AuthService();
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

  void navSignUp(BuildContext context) {
    Navigator.of(context).pushNamed('/sign_up');
  }

  void navSignIn(BuildContext context) {
    Navigator.of(context).pushNamed('/sign_in');
  }

  void navSignOut(BuildContext context) {
    Navigator.of(context).pushNamed('/sign_out');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> _buildMenu() {
    List<Widget> widgets = new List<Widget>();

    //if(_authService.isAuthorize())
    //{
      //widgets.add(
      //  new ListTile(
      //    subtitle: CircleAvatar(child: Icon(Icons.verified_user)),
      //  )
      //);
    //}
    //else
    //{
      widgets.add(new ListTile(title: new Text("Menu")));
    //}

    widgets.add(new Divider());

    //if(_authService.isAuthorize())
    //{
    //  widgets.add(
    //    new ListTile(
    //      title: new Text("Stocks(Refresh, Dismissible)"),
    //      trailing: new Icon(Icons.card_travel),
    //      onTap: () {
    //        Navigator.of(context).pop();
    //        navStocks(context);
    //      }
    //    )
    //  );

      widgets.add(
        new ListTile(
          title: new Text("Dynamic Tiles(Timer)"),
          trailing: new Icon(Icons.filter_tilt_shift),
          onTap: () {
            Navigator.of(context).pop();
            navIsolate(context);
          }
        )
      );

      widgets.add(
        new ListTile(
          title: new Text("Scoped Model"),
          trailing: new Icon(Icons.card_travel),
          onTap: () {
            Navigator.of(context).pop();
            navScoped(context);
          }
        )
      );

      widgets.add(
        new ListTile(
          title: new Text("Jokes(Online)"),
          trailing: new Icon(Icons.thumbs_up_down),
          onTap: () {
            Navigator.of(context).pop();
            navJokes(context);
          }
        )
      );

      widgets.add(
        new ListTile(
          title: new Text("Votes(Firebase)"),
          trailing: new Icon(Icons.directions_car),
          onTap: () {
            Navigator.of(context).pop();
            navAuto(context);
          }
        )
      );
    //}
    //else
    //{
      widgets.add(
        new ListTile(
          title: new Text("Sign Up"),
          trailing: new Icon(Icons.arrow_upward),
          onTap: () {
            Navigator.of(context).pop();
            navSignUp(context);
          }
        )
      );

    widgets.add(
        new ListTile(
            title: new Text("Sign In"),
            trailing: new Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              navSignIn(context);
            }
        )
    );

    widgets.add(
        new ListTile(
            title: new Text("Sign Out"),
            trailing: new Icon(Icons.arrow_downward),
            onTap: () {
              Navigator.of(context).pop();
              navSignOut(context);
            }
        )
    );
    //}

    return widgets;
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
              children: _buildMenu()
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
  final AuthService _authService = new AuthService();

  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState(),
    middleware: []
      ..addAll(createAuthMiddleware())
      ..add(LoggingMiddleware.printer())
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
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
          '/sign_up': (BuildContext context) => new SignUpPage(_authService),
          '/sign_in': (BuildContext context) => new SignInPage(),
          '/sign_out': (BuildContext context) => new SignInPage(),
        },
      )
    );
  }
}
