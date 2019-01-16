import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/first_tab.dart';
import 'package:flutter_app/tabs/second_tab.dart';
import 'package:flutter_app/tabs/third_tab.dart';
import 'package:flutter_app/pages/info_page.dart';

/*
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i){
          if(i.isOdd) return new Divider();

          print('i: $i');

          return new ListTile(title: new Text(_items[i]));
        }
    );
  }
  */

void main() => runApp(App());


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin
{
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
              appBar: new AppBar(
                leading: new Icon(Icons.menu),
                title: new Text("App"),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.info),
                    onPressed: () => navInfo(context),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.monetization_on),
                    onPressed: () {},
                  )
                ],
              ),

              body: new TabBarView(
                // Add tabs as widgets
                children: <Widget>[
                  new FirstTab(), new SecondTab(), new ThirdTab()],
                // set the controller
                controller: controller,
              ),
              drawer: new Drawer(
                child: new ListView(
                  children: [
                    new ListTile(
                      title: new Text("Welcome to App"),
                    ),
                    new Divider(),
                    new ListTile(
                        title: new Text("Sample Form"),
                        trailing: new Icon(Icons.edit),
                        onTap: () {
                          Navigator.of(context).pop();
                          navInfo(context);
                        }),
                    new ListTile(
                        title: new Text("About"),
                        trailing: new Icon(Icons.info),
                        onTap: () {
                          Navigator.of(context).pop();
                          navInfo(context);
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
                      icon: new Icon(Icons.person_add),
                    ),
                    new Tab(
                      icon: new Icon(Icons.airport_shuttle),
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
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new HomePage(),
        '/info': (BuildContext context) => new InfoPage(),
      },
    );
  }
}