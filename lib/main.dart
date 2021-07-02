
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:records/ui/screens/splashscreens/splashscreen_view.dart';
import 'package:records/utils/constants/colors.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogManager.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';
import 'package:records/utils/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Manager',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<ProgressService>().progressNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => ProgressManager(child: child) ,
        ),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          accentColor: AppColors.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Caros'),
      home: SplashscreenView(),
      onGenerateRoute: generateRoute,
    );
  }
}
