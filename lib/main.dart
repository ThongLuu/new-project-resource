// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:news_app/cubits/articles/cubit.dart';
// import 'package:news_app/cubits/authentication/cubit.dart';
// import 'package:news_app/cubits/authentication/repository.dart';
// import 'package:news_app/cubits/login/repository.dart';
// import 'package:news_app/cubits/top_headlines/cubit.dart';
// import 'package:news_app/models/article/article.dart';
// import 'package:news_app/models/article/article_source.dart';
// import 'package:news_app/models/news.dart';
// import 'package:news_app/providers/category_provider.dart';
// import 'package:news_app/providers/tab_provider.dart';
// import 'package:news_app/providers/theme_provider.dart';
// import 'package:news_app/screens/dashboard/dashboard.dart';
// import 'package:news_app/screens/login/login_screen.dart';
// import 'package:news_app/screens/scan/scan.dart';
// import 'package:news_app/screens/splash/splash.dart';
// import 'package:news_app/screens/top_stories/top_stories.dart';
// import 'package:provider/provider.dart';
// import 'configs/core_theme.dart' as theme;

// void main() async {
//   await Hive.initFlutter();

//   await dotenv.load(fileName: ".env");

//   Hive.registerAdapter<News>(NewsAdapter());
//   Hive.registerAdapter<Article>(ArticleAdapter());
//   Hive.registerAdapter<ArticleSource>(ArticleSourceAdapter());

//   await Hive.openBox('app');
//   await Hive.openBox('newsBox');
//   await Hive.openBox('articlesbox');

//   runApp(MyApp(
//     authenticationRepository: AuthenticationRepository(),
//     userRepository: UserRepository(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   final AuthenticationRepository authenticationRepository;
//   final UserRepository userRepository;

//   const MyApp(
//       {Key? key,
//       required this.authenticationRepository,
//       required this.userRepository})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     return RepositoryProvider.value(
//       value: this.authenticationRepository,
//       child: BlocProvider(
//         create: (_) => AuthenticationBloc(
//             authenticationRepository: authenticationRepository,
//             userRepository: userRepository),
//         child: MultiProvider(
//           providers: [
//             BlocProvider(create: (_) => ArticlesCubit()),
//             BlocProvider(create: (_) => TopHeadlinesCubit()),
//             ChangeNotifierProvider(create: (_) => TabProvider()),
//             ChangeNotifierProvider(create: (_) => ThemeProvider()),
//             ChangeNotifierProvider(create: (_) => CategoryProvider()),
//           ],
//           child: Consumer<ThemeProvider>(
//             builder: (context, themeProvider, child) {
//               return MainApp(
//                 provider: themeProvider,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MainApp extends StatefulWidget {
//   final ThemeProvider provider;
//   const MainApp({
//     Key? key,
//     required this.provider,
//   }) : super(key: key);

//   @override
//   MaterialChild createState() => MaterialChild();
// }

// class MaterialChild extends State<MainApp>{
//   final _navigatorKey = GlobalKey<NavigatorState>();

//   NavigatorState get _navigator => _navigatorKey.currentState!;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: _navigatorKey,
//       title: 'News App',
//       debugShowCheckedModeBanner: false,
//       themeMode: widget.provider.isDark ? ThemeMode.dark : ThemeMode.light,
//       theme: theme.themeLight,
//       darkTheme: theme.themeDark,
//       initialRoute: '/login',
//       routes: {
//         '/splash': (context) => const SplashScreen(),
//         '/dashboard': (context) => const DashboardScreen(),
//         '/top-stories': (context) => const TopStoriesScreen(),
//         '/login': (context) => LoginScreen(),
//         '/scan': (context) => const ScanScreen(),
//       },
//       builder: (context, child) {
//         return BlocListener<AuthenticationBloc, AuthenticationState>(
//           listener: (context, state) {
//             switch (state.status) {
//               case AuthenticationStatus.authenticated:
//                 _navigator.pushAndRemoveUntil<void>(
//                     DashboardScreen.route(), (route) => false);
//                 break;
//               case AuthenticationStatus.unauthenticated:
//                 _navigator.pushAndRemoveUntil<void>(
//                     LoginScreen.route(), (route) => false);
//                 break;
//               default:
//                 break;
//             }
//           },
//           child: child,
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}