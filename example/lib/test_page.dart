import 'package:flutter/material.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void showCupertinoOverlay() {
    Navigator.of(context).push(
      CupertinoBottomSheetRoute(
        args: CupertinoBottomSheetRouteArgs(
          swipeSettings: const SwipeSettings(
            canCloseBySwipe: true,
          ),
          appBar: CupertinoBottomSheetAppBar.withCloseIcon(
            title: 'Cupertino Actionsheet',
            onClosePressed: Navigator.of(context).pop,
          ),
        ),
        builder: (context) {
          return const TestPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.red,
              onPressed: showCupertinoOverlay,
              child: const Text(
                'Open Cupertino Sheet',
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                /// this will work if you pass cupertinoBottomSheetNavigatorKey
                /// to your MaterialApp (or other type of apps that have a navigatorKey parameter)
                openCupertinoBottomSheet(
                  builder: (c) {
                    return const TestPage();
                  },
                  args: CupertinoBottomSheetRouteArgs(
                    appBar: CupertinoBottomSheetAppBar.withCloseButton(
                      title: 'Cupertino Actionsheet',
                      buttonText: 'Done',
                      headerStyle: Theme.of(context).textTheme.bodyMedium,
                      onClosePressed: Navigator.of(context).pop,
                    ),
                  ),
                );
              },
              child: const Text(
                'Open Cupertino Sheet without context',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
