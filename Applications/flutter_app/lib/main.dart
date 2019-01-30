import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/third_tab.dart';
import 'package:flutter_app/pages/info_page.dart';
import 'package:flutter_app/pages/home_page.dart';
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

class App extends StatelessWidget
{
  final AuthService _authService = new AuthService();

  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState(),
    middleware: []
      ..addAll(createAuthMiddlewares())
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
          '/': (BuildContext context) => new HomePage(cameras),
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
