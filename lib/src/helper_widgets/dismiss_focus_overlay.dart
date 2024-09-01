import 'package:flutter/widgets.dart';

/// {@template DismissFocusOverlay}
/// A utility widget that when tapped dismisses the current focus, if any
/// {@endtemplate}
class DismissFocusOverlay extends StatelessWidget {
  /// {@macro DismissFocusOverlay}
  const DismissFocusOverlay({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}
