import 'package:flutter/material.dart';
import 'package:four_diary/screen/main_screen.dart';
import 'package:four_diary/screen/write_screen.dart';

import 'model/diary_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네컷일기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: MainScreen(),
      routes: {'/main': (context) => const MainScreen()},
      onGenerateRoute: (settings) {
        if (settings.name == '/write') {
          final DiaryModel? diaryModel = settings.arguments as DiaryModel?;
          return MaterialPageRoute(
            builder: (context) {
              return WriteScreen(diaryModel: diaryModel);
            },
          );
        }
      },
    );
  }
}