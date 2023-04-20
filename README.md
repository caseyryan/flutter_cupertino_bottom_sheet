A package that mimics a Cupertino Style bottom sheet like this

https://pub.dev/packages/flutter_cupernino_bottom_sheet

![Apr-20-2023 11-43-53](https://user-images.githubusercontent.com/4113558/233260343-c128dac5-198f-4ecc-abcf-13b590e98a3e.gif)



Unlike existing packages that can mimic the same behavior flutter_cupernino_bottom_sheet does not require
a scaffold for this purpose and can be used from any place and any time. 
You don't have to use any special code except for wrapping your MaterialApp 
with CupertinoBottomSheetRepaintBoundary() at the beginning. And that's it. 
That simple. You don't even need a specific context for it to work 

## How it works. 
It's very simple. Internally it uses a repaint boundary to create a screenshot 
of the whole screen and make a RawImage out of it. So it doesn't matter if the 
previous route maintains its state or not. It doesn't really need to know 
anything about the previous route as it uses a screenshot instead of a widget 
snapshot

## Getting started

import the package where you initialize your app

```dart
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';
```

And then wrap your MaterialApp or whatever type you use with CupertinoBottomSheetRepaintBoundary

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoBottomSheetRepaintBoundary(
      child: MaterialApp(
        ...
      ),
    );
  }
}
```
This will provide a necessary RenderRepaintBoundary for the library to work. 

Then you can use a Navigator to push this route like this:
```dart
Navigator.of(context).push(
    CupertinoBottomSheetRoute(
        args: const CupertinoBottomSheetRouteArgs(
            swipeSettings: SwipeSettings(
            canCloseBySwipe: true,
            ),
        ),
        builder: (context) {
            return const TestPage();
        },
    ),
);
```

###  Want less code? No problem.

Pass a cupertinoBottomSheetNavigatorKey to your App initialization

```dart 
@override
Widget build(BuildContext context) {
  return CupertinoBottomSheetRepaintBoundary(
    child: MaterialApp(
      navigatorKey: cupertinoBottomSheetNavigatorKey,
      ...
    ),
  );
}
```

And then call openCupertinoBottomSheet() from any place, regardless of context

```dart
openCupertinoBottomSheet(builder: (c) {
    return const TestPage();
});
```
