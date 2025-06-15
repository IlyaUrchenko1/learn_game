import 'package:flutter/material.dart';
import 'package:learn_game/views/home/home_screen.dart';
import 'package:learn_game/views/leaderboard/leaderboard_screen.dart';
import 'package:learn_game/views/profile/profile_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Symbols.stadia_controller_rounded),
            activeIcon: Icon(Symbols.stadia_controller_rounded, fill: 1),
            label: 'Игра',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.leaderboard_rounded),
            activeIcon: Icon(Symbols.leaderboard_rounded, fill: 1),
            label: 'Топ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.account_circle_rounded),
            activeIcon: Icon(Symbols.account_circle_rounded, fill: 1),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
