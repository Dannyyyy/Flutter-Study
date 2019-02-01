import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/first_tab.dart';
import 'package:flutter_app/tabs/second_tab.dart';
import 'package:flutter_app/tabs/third_tab.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/redux/models/authorization.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/app_state.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController controller;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> _buildMenu(HomeStore store) {
    bool isAuthorize = store.auth?.isAuthorize ?? false;

    List<Widget> widgets = new List<Widget>();

    if(isAuthorize) {
      widgets.add(
        new ListTile(
          trailing: CircleAvatar(child: Icon(Icons.verified_user)),
          title: new Text("Hello, ${store.auth.user.email}"),
       )
      );
    } else {
      widgets.add(new ListTile(title: new Text("Welcome to App")));
    }

    widgets.add(new Divider());

    if(isAuthorize) {
      widgets.add(
        new ListTile(
          title: new Text("Stocks(Refresh, Dismissible)"),
          trailing: new Icon(Icons.card_travel),
          onTap: () {
            Navigator.of(context).pop();
            navStocks(context);
          }
        )
      );
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
      widgets.add(new Divider());
      widgets.add(
        new ListTile(
          title: new Text("Sign Out"),
          trailing: new Icon(Icons.arrow_downward),
          onTap: () {
            store.onLogOutPressedCallback();
          }
        )
      );
    } else {
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
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {

    return new Builder(builder: (context) =>
      StoreConnector<AppState, HomeStore>(
        converter: HomeStore.fromStore,
        builder: (BuildContext context, HomeStore model) {
          return new Scaffold(
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
                new FirstTab(_scaffoldKey),
                new SecondTab(),
                new CameraExampleHome(cameras: widget.cameras)
              ],
              // set the controller
              controller: controller,
            ),
            drawer: new Drawer(
              child: new ListView(
                children: _buildMenu(model)
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
          );
        }
      )
    );
  }
}

class HomeStore {
  final Function onLogOutPressedCallback;
  final Auth auth;

  HomeStore({this.onLogOutPressedCallback, this.auth});

  static HomeStore fromStore(Store<AppState> store) {
    return new HomeStore(
      onLogOutPressedCallback: () {
        store.dispatch(LogOut());
      },
      auth: store.state.auth
    );
  }
}