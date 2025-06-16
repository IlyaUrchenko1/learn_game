import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learn_game/core/theme/app_theme.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/providers/name_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NameProvider()),
        ChangeNotifierProxyProvider<NameProvider, ProgressProvider>(
          create: (context) => ProgressProvider(),
          update: (context, nameProvider, progressProvider) {
            if (progressProvider == null) return ProgressProvider();
            progressProvider.updateNameProvider(nameProvider);
            return progressProvider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Learn Game',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru', 'RU')],
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
