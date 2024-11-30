import 'package:admin_dashboard/src/di/service_locator.dart';
import 'package:admin_dashboard/src/navigation/routes.dart';
import 'package:admin_dashboard/src/pages/homepage/homepage.dart';
import 'package:admin_dashboard/src/providers/user_provider.dart';
import 'package:admin_dashboard/src/res/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'src/navigation/navigation_service.dart';
import 'src/pages/routes/routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ServiceLocator().setUp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELTalk Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: FontFamily.dmSans),
      navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
      initialRoute: PageRoutes.root,
      onGenerateRoute: routes,
      home: const Homepage(),
    );
  }
}
