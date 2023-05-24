import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Wrap your MaterialApp with this widget like this
/// Widget build(BuildContext context) {
///    return CupertinoBottomSheetRepaintBoundary(
///      child: MaterialApp(
///        title: 'Flutter Cupertino Bottom Sheet',
///        theme: ThemeData(
///          primarySwatch: Colors.red,
///        ),
///        home: const TestPage(),
///      ),
///    );
///  }
///
///  The purpose of
/// this is to create a repaint boundary for the whole screen and
/// provide a repaint boundary key to the route
class CupertinoBottomSheetRepaintBoundary extends StatelessWidget {
  final Widget child;
  const CupertinoBottomSheetRepaintBoundary({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: child,
    );
  }
}

class SwipeSettings {
  final bool canCloseBySwipe;
  final double velocityThreshhold;
  final bool onlySwipesFromEdges;
  final double interactiveEdgeWidth;

  /// [canCloseBySwipe] if false, the bottomsheet will not
  /// close if a user swipes down
  /// [velocityThreshhold] the bigger this value, the faster you need
  /// to swipe to close the bottomsheet
  /// [onlySwipesFromEdges] if true, will only allow swipes from a
  /// top side
  /// [interactiveEdgeWidth] the width of the edge that
  /// is interactive while dragging.
  /// Works only if [onlySwipesFromEdges] is true
  const SwipeSettings({
    this.canCloseBySwipe = true,
    this.velocityThreshhold = 150.0,
    this.onlySwipesFromEdges = false,
    this.interactiveEdgeWidth = 100.0,
  });
}

class CupertinoBottomSheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? headerStyle;
  final EdgeInsets? padding;

  const CupertinoBottomSheetAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.leading,
    this.headerStyle,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
  });

  factory CupertinoBottomSheetAppBar.withCloseButton({
    required String title,
    required String buttonText,
    VoidCallback? onClosePressed,
    TextStyle? headerStyle,
    TextStyle? buttonTextStyle,
  }) {
    return CupertinoBottomSheetAppBar(
      title: title,
      headerStyle: headerStyle,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onClosePressed,
        child: Text(
          buttonText,
          style: buttonTextStyle,
        ),
      ),
    );
  }
  factory CupertinoBottomSheetAppBar.withCloseIcon({
    required String title,
    VoidCallback? onClosePressed,
    TextStyle? headerStyle,
    Color? iconColor,
  }) {
    return CupertinoBottomSheetAppBar(
      title: title,
      padding: null,
      headerStyle: headerStyle,
      trailing: IconButton(
        splashRadius: kToolbarHeight * .4,
        icon: Icon(
          Icons.close,
          color: iconColor ?? headerStyle?.color,
        ),
        onPressed: onClosePressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(
              flex: 18,
              child: SizedBox(
                child: leading,
              ),
            ),
            Expanded(
              flex: 74,
              child: Center(
                child: SizedBox(
                  child: Text(
                    title,
                    style: headerStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 18,
              child: SizedBox(
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class CupertinoBottomSheetRouteArgs {
  final bool maintainState;
  final SwipeSettings swipeSettings;
  final Color shadeColor;
  final Color? scaffoldBackgroundColor;
  final String? barrierLabel;
  final PreferredSizeWidget? appBar;

  const CupertinoBottomSheetRouteArgs({
    this.maintainState = false,
    this.swipeSettings = const SwipeSettings(),
    this.shadeColor = Colors.black,
    this.scaffoldBackgroundColor,
    this.barrierLabel,
    this.appBar,
  });
}

typedef ChildBuilder = Widget Function(BuildContext context);

class CupertinoBottomSheetRoute extends ModalRoute {
  final CupertinoBottomSheetRouteArgs args;
  final ChildBuilder builder;

  CupertinoBottomSheetRoute({
    this.args = const CupertinoBottomSheetRouteArgs(),
    required this.builder,
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => args.barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _CupertinoRouteBuilder(
      animation: animation,
      args: args,
      builder: builder,
    );
  }

  @override
  bool get maintainState => args.maintainState;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;
}

class _CupertinoRouteBuilder extends StatefulWidget {
  final CupertinoBottomSheetRouteArgs args;
  final Animation<double> animation;
  final ChildBuilder builder;

  const _CupertinoRouteBuilder({
    required this.animation,
    required this.builder,
    required this.args,
  });

  @override
  State<_CupertinoRouteBuilder> createState() => __CupertinoRouteBuilderState();
}

class __CupertinoRouteBuilderState extends State<_CupertinoRouteBuilder>
    with _PostFrameMixin {
  RawImage? _snapshot;
  static int _numRoutes = 0;
  int _curRouteNumber = 0;

  @override
  void initState() {
    _curRouteNumber = _numRoutes;
    _numRoutes++;
    super.initState();
  }

  RenderRepaintBoundary get renderRepaintBoundary {
    return _repaintBoundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
  }

  Future<RawImage> takeScreenshot() async {
    final image = await renderRepaintBoundary.toImage();
    return RawImage(
      image: image,
    );
  }

  @override
  Future didFirstLayoutFinished(BuildContext context) async {
    _snapshot = await takeScreenshot();
    if (_snapshot != null) {
      setState(() {});
    } else {
      if (kDebugMode) {
        print('''
          Wrap your App with CupertinoBottomSheetRepaintBoundary()
        ''');
      }
    }
  }

  @override
  void dispose() {
    _numRoutes--;
    if (_numRoutes < 0) {
      _numRoutes = 0;
    }
    super.dispose();
  }

  Widget _buildSnapshot() {
    /// it's a smal hack to position the first route snapshot
    /// into a correct position while zooming the stack out
    if (_curRouteNumber == 0) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: _snapshot!,
      );
    }
    return _snapshot!;
  }

  Widget _buildChild() {
    final child = widget.builder(context);
    if (widget.args.swipeSettings.canCloseBySwipe) {
      return _SwipeDetector(
        acceptedSwipes: _AcceptedSwipes.vertical,
        velocityThreshhold: widget.args.swipeSettings.velocityThreshhold,
        interactiveEdgeWidth: widget.args.swipeSettings.interactiveEdgeWidth,
        onlySwipesFromEdges: widget.args.swipeSettings.onlySwipesFromEdges,
        onSwipe: (_SwipeDirection direction) {
          if (direction == _SwipeDirection.topToBottom) {
            Navigator.pop(context);
          }
        },
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    if (_snapshot == null) {
      return const SizedBox.shrink();
    }

    final topNotch = MediaQuery.of(context).viewPadding.top;
    const kTopOffset = 10.0;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        double top = 0.0;
        if (_curRouteNumber == 0) {
          top = (topNotch - kTopOffset + 5.0) * widget.animation.value;
        } else {
          top = -kTopOffset * widget.animation.value;
        }
        return Container(
          height: double.infinity,
          color: widget.args.shadeColor,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(
                  0.0,
                  top,
                ),
                child: Transform.scale(
                  alignment: Alignment.topCenter,
                  scale: 1.0 - (.1 * widget.animation.value),
                  child: _buildSnapshot(),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: widget.args.shadeColor.withOpacity(
                  .16 * widget.animation.value,
                ),
              ),
              Transform.translate(
                transformHitTests: true,
                offset: Offset(
                  0.0,
                  screenHeight * (1.0 - widget.animation.value),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topNotch + kTopOffset,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),

                    /// fixes this issue https://github.com/flutter/flutter/issues/51345
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scaffold(
                        appBar: widget.args.appBar,
                        resizeToAvoidBottomInset: false,
                        extendBodyBehindAppBar: true,
                        backgroundColor: widget.args.scaffoldBackgroundColor,
                        body: Padding(
                          padding: EdgeInsets.only(
                            top: widget.args.appBar != null ? kToolbarHeight : 0.0,
                          ),
                          child: _buildChild(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final GlobalKey _repaintBoundaryKey = GlobalKey();

/// can be used to simplify bottom sheet opening without the need for context
final GlobalKey<NavigatorState> cupertinoBottomSheetNavigatorKey = GlobalKey();

Future openCupertinoBottomSheet({
  required ChildBuilder builder,
  CupertinoBottomSheetRouteArgs? args,
}) async {
  if (cupertinoBottomSheetNavigatorKey.currentState == null) {
    throw '''
      No navigator state has been found. Add cupertinoBottomSheetNavigatorKey as a 
      navigatorKey argument of your App initialization
      example: 
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
    ''';
  }
  return cupertinoBottomSheetNavigatorKey.currentState!.push(
    CupertinoBottomSheetRoute(
      args: args ??
          const CupertinoBottomSheetRouteArgs(
            swipeSettings: SwipeSettings(
              canCloseBySwipe: true,
            ),
          ),
      builder: builder,
    ),
  );
}

mixin _PostFrameMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (mounted) {
          didFirstLayoutFinished(context);
        }
      },
    );
  }

  void didFirstLayoutFinished(BuildContext context);

  void callAfterFrame(ValueChanged<BuildContext> fn) {
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        fn.call(context);
      }
    });
  }
}

enum _SwipeDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

enum _AcceptedSwipes {
  all,
  horizontal,
  vertical,
}

class _SwipeDetector extends StatefulWidget {
  final Widget child;
  final double velocityThreshhold;
  final ValueChanged<_SwipeDirection> onSwipe;
  final _AcceptedSwipes acceptedSwipes;
  final bool onlySwipesFromEdges;
  final double interactiveEdgeWidth;

  /// [onlySwipesFromEdges] если нужно разрешить только
  /// свайпы от края экрана
  const _SwipeDetector({
    Key? key,
    required this.child,
    required this.onSwipe,
    this.velocityThreshhold = 150.0,
    this.onlySwipesFromEdges = false,
    this.interactiveEdgeWidth = 100.0,
    this.acceptedSwipes = _AcceptedSwipes.all,
  }) : super(key: key);

  @override
  State<_SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<_SwipeDetector> {
  Offset? _startPosition;
  final Stopwatch _stopwatch = Stopwatch();
  int _lastMillis = 0;

  @override
  void initState() {
    _stopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  bool _isSupportedDirection(_SwipeDirection direction) {
    if (widget.acceptedSwipes == _AcceptedSwipes.all) {
      return true;
    } else if (widget.acceptedSwipes == _AcceptedSwipes.horizontal) {
      if (direction == _SwipeDirection.leftToRight ||
          direction == _SwipeDirection.rightToLeft) {
        return true;
      }
    } else if (widget.acceptedSwipes == _AcceptedSwipes.vertical) {
      if (direction == _SwipeDirection.topToBottom ||
          direction == _SwipeDirection.bottomToTop) {
        return true;
      }
    }
    return false;
  }

  void _onHorizontalSwipe(_SwipeDirection direction) {
    if (_isSupportedDirection(direction)) {
      widget.onSwipe(direction);
    }
  }

  void _onVerticalSwipe(_SwipeDirection direction) {
    if (_isSupportedDirection(direction)) {
      widget.onSwipe(direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, BoxConstraints constraints) {
        return Listener(
          onPointerUp: (details) {
            final newPosition = details.localPosition;
            final diffX = (newPosition.dx).abs() - (_startPosition!.dx).abs();
            final diffY = (newPosition.dy).abs() - (_startPosition!.dy).abs();
            final velocityXAbs = max(diffX.abs(), 0.001);
            final velocityYAbs = max(diffY.abs(), 0.001);

            final delta =
                max(velocityXAbs, velocityYAbs) / min(velocityXAbs, velocityYAbs);
            final isAmbiguous = delta < 1.32;
            if (isAmbiguous) {
              return;
            }
            final isHorizontalSwipe = velocityXAbs > velocityYAbs;
            if (isHorizontalSwipe) {
              if (velocityXAbs < widget.velocityThreshhold) {
                return;
              }
              final fromLeft = newPosition.dx - _startPosition!.dx > 0;
              final direction =
                  fromLeft ? _SwipeDirection.leftToRight : _SwipeDirection.rightToLeft;
              if (!_isSupportedDirection(direction)) {
                return;
              }
              if (widget.onlySwipesFromEdges) {
                if (fromLeft) {
                  if (_startPosition!.dx > widget.interactiveEdgeWidth) {
                    return;
                  }
                } else {
                  if (_startPosition!.dx <
                      constraints.biggest.width - widget.interactiveEdgeWidth) {
                    return;
                  }
                }
              }
              _onHorizontalSwipe(direction);
            } else {
              if (velocityYAbs < widget.velocityThreshhold) {
                return;
              }
              final fromTop = newPosition.dy - _startPosition!.dy > 0;
              final direction =
                  fromTop ? _SwipeDirection.topToBottom : _SwipeDirection.bottomToTop;
              if (!_isSupportedDirection(direction)) {
                return;
              }
              if (widget.onlySwipesFromEdges) {
                if (fromTop) {
                  if (_startPosition!.dy > widget.interactiveEdgeWidth) {
                    return;
                  }
                } else {
                  if (_startPosition!.dy <
                      constraints.biggest.height - widget.interactiveEdgeWidth) {
                    return;
                  }
                }
              }
              _onVerticalSwipe(direction);
            }
          },
          onPointerDown: (details) {
            _startPosition = details.localPosition;
            _lastMillis = _stopwatch.elapsed.inMilliseconds;
          },
          onPointerMove: (details) {
            final newMillis = _stopwatch.elapsed.inMilliseconds;
            final millisDiff = newMillis - _lastMillis;
            if (millisDiff >= 300) {
              _startPosition = details.localPosition;
              _lastMillis = newMillis;
            }
          },
          child: widget.child,
        );
      },
    );
  }
}
