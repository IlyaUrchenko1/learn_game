import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:learn_game/views/game/guide_screen.dart';
import 'package:learn_game/views/game/result_screen.dart';
import 'package:learn_game/views/game/test_screen.dart';
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
        onGenerateRoute: (settings) {
          if (settings.name == GuideScreen.routeName) {
            final level = settings.arguments as Level;
            return MaterialPageRoute(
              builder: (context) => GuideScreen(level: level),
            );
          }
          if (settings.name == TestScreen.routeName) {
            final level = settings.arguments as Level;
            return MaterialPageRoute(
              builder: (context) => TestScreen(level: level),
            );
          }
          if (settings.name == ResultScreen.routeName) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ResultScreen(
                score: args['score'] as int,
                total: args['total'] as int,
                levelId: args['levelId'] as int,
              ),
            );
          }
          return null; // Let routes handle it
        },
        routes: {'/': (context) => const MainNavigation()},
      ),
    );
  }
}
