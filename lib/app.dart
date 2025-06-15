import 'package:flutter/material.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:learn_game/views/main_navigation.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProgressProvider(),
      child: MaterialApp(
        title: 'Learn Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {'/': (context) => const MainNavigation()},
      ),
    );
  }
}
