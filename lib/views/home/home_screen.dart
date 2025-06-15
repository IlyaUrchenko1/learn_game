import 'package:flutter/material.dart';
import 'package:learn_game/data/levels_data.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:learn_game/views/game/guide_screen.dart';
import 'package:learn_game/views/home/level_node.dart';
import 'package:learn_game/views/home/level_path_painter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCourse = 'Flutter';

  @override
  Widget build(BuildContext context) {
    const double nodeSpacing = 120.0;
    const double nodeRadius = 30.0;
    final double topPadding = 50.0;
    final double pathHeight =
        (allLevels.length * nodeSpacing) + topPadding * 2 - (nodeRadius * 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Путь обучения'),
        centerTitle: true,
        actions: [_buildCourseSelector(context)],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: pathHeight,
                  width: constraints.maxWidth,
                  child: CustomPaint(
                    painter: LevelPathPainter(),
                    child: Stack(
                      children: List.generate(allLevels.length, (index) {
                        final level = allLevels[index];
                        final isCompleted = progressProvider.isCompleted(
                          level.id,
                        );
                        final isLocked =
                            index > 0 &&
                            !progressProvider.isCompleted(
                              allLevels[index - 1].id,
                            );

                        final position = Offset(
                          constraints.maxWidth / 2,
                          topPadding + (index * nodeSpacing),
                        );

                        return Positioned(
                          top: position.dy - nodeRadius,
                          left: position.dx - nodeRadius,
                          child: LevelNode(
                            level: level,
                            isCompleted: isCompleted,
                            isLocked: isLocked,
                            onTap: () {
                              if (!isLocked) {
                                Navigator.pushNamed(
                                  context,
                                  GuideScreen.routeName,
                                  arguments: level,
                                );
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseSelector(BuildContext context) {
    final courses = ['Flutter', 'Python', 'JavaScript', 'C#', 'Go'];
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value != 'Flutter') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Курс по $value скоро появится!'),
              backgroundColor: theme.colorScheme.secondary,
            ),
          );
        } else {
          setState(() {
            _selectedCourse = value;
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return courses.map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Chip(
          avatar: const Icon(Icons.book),
          label: Text(_selectedCourse),
          backgroundColor: theme.colorScheme.surfaceVariant,
        ),
      ),
    );
  }
}
