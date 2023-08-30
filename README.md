## A package that mimics a Cupertino bottom sheet like this VERY EASILY

<a href="https://pub.dev/packages/flutter_cupertino_bottom_sheet"><img src="https://img.shields.io/pub/v/flutter_cupertino_bottom_sheet?logo=dart" alt="pub.dev"></a>[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart) <a href="https://github.com/Solido/awesome-flutter">
<img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>


![Apr-20-2023 11-43-53](https://user-images.githubusercontent.com/4113558/233260343-c128dac5-198f-4ecc-abcf-13b590e98a3e.gif)



Unlike existing packages that can mimic the same behavior flutter_cupertino_bottom_sheet does not require
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
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';
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
    args: CupertinoBottomSheetRouteArgs(
      appBar: CupertinoBottomSheetAppBar.withCloseButton(
        title: 'Cupertino Actionsheet',
        buttonText: 'Done',
        headerStyle: Theme.of(context).textTheme.bodyMedium,
        onClosePressed: Navigator.of(context).pop,
      ),
    ),
});
```
