import 'package:flutter/material.dart';
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';

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

  void showCupertinoOverlayWithScroller() {
    Navigator.of(context).push(
      CupertinoBottomSheetRoute(
        args: CupertinoBottomSheetRouteArgs(
          swipeSettings: const SwipeSettings(
            canCloseBySwipe: true,
          ),
          appBar: CupertinoBottomSheetAppBar.withCloseIcon(
            title: 'Scrolled',
            onClosePressed: Navigator.of(context).pop,
          ),
        ),
        builder: (context) {
          final controller = CupertinoBottomSheet.of(context)?.scrollController;
          return Scaffold(
            body: CustomScrollView(
              controller: controller,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      100,
                      (index) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.red.withOpacity(1 / ((index % 10) + 1)),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
          );
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
            const SizedBox(height: 50.0),
            MaterialButton(
              color: Colors.orange,
              onPressed: showCupertinoOverlayWithScroller,
              child: const Text(
                'Open Cupertino Sheet With Scroller',
              ),
            ),
            const SizedBox(height: 50.0),
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
