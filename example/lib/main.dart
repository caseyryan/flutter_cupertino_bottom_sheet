import 'package:flutter/material.dart';
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';

import 'test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoBottomSheetRepaintBoundary(
      child: MaterialApp(
        navigatorKey: cupertinoBottomSheetNavigatorKey,
        title: 'Flutter Cupertino Bottom Sheet',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const TestPage(),
      ),
    );
  }
}
