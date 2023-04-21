import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakuro/Objects/AppProvider.dart';
import 'package:provider/provider.dart';
import 'Objects/UserPreferences.dart';
import 'Pages/HomePage.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI
  await SystemChrome.setPreferredOrientations([ // Permet de bloquer l'orientation
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await FlutterDisplayMode.setHighRefreshRate(); // Permet d'aller au dela de 60Hz

  await UserPreferences().initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppProvider()),
        ],
        child: MaterialApp(
          title: 'IcyApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Lato', useMaterial3: true),
          home: const HomePage(),
        )
    );
  }
}
