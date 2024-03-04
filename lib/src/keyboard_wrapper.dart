import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardWrapper extends StatefulWidget {
  static VoidCallback? onDonePressed;

  final Widget child;
  final Widget? contents;
  final Color? backgroundColor;
  final double height;
  final bool iosOnly;
  final ValueChanged<bool>? onKeyboardVisibilityChange;
  final String? buttonText;
  final bool isEnabled;

  const KeyboardWrapper({
    Key? key,
    required this.child,
    this.contents,
    this.onKeyboardVisibilityChange,
    this.backgroundColor,
    this.buttonText,
    this.height = 40.0,
    this.iosOnly = false,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<KeyboardWrapper> createState() => _KeyboardWrapperState();
}

class _KeyboardWrapperState extends State<KeyboardWrapper> {
  bool _isKeyboardVisible = false;

  Widget _buildContents() {
    if (widget.contents != null) {
      return widget.contents!;
    }
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          key: const Key('over_keyboard_done'),
          onTap: () {
            FocusScope.of(context).focusedChild?.unfocus();
            KeyboardWrapper.onDonePressed?.call();
          },
          child: Container(
            color: Colors.transparent,
            height: widget.height,
            child: IgnorePointer(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildDoneButton(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Icon(
        Icons.keyboard_hide,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _buildView(bool isVisible) {
    if (_isKeyboardVisible != isVisible) {
      _isKeyboardVisible = isVisible;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onKeyboardVisibilityChange?.call(isVisible);
      });
    }
    return Column(
      children: [
        Expanded(
          child: widget.child,
        ),
        Offstage(
          offstage: !isVisible,
          child: Opacity(
            opacity: isVisible ? 1.0 : 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomDivider(),
                Material(
                  animationDuration: Duration.zero,
                  elevation: 10.0,
                  color: widget.backgroundColor ?? Theme.of(context).canvasColor,
                  child: SizedBox(
                    height: widget.height,
                    width: double.infinity,
                    child: _buildContents(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return widget.child;
    }
    if (kIsWeb) {
      return widget.child;
    }
    if (widget.iosOnly) {
      if (!Platform.isIOS) {
        return widget.child;
      }
    }
    return KeyboardVisibilityBuilder(
      builder: (c, bool isVisible) {
        return _buildView(isVisible);
      },
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height = .2,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
    );
  }
}
