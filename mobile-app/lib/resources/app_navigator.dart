import 'package:flutter/material.dart';

class AppNavigator {
  static void pushReplacement(BuildContext context, Widget widget, {RouteTransitionsBuilder? transition}) {
    Navigator.pushReplacement(
      context,
      _createPageRoute(widget, transition: transition),
    );
  }

  static void push(BuildContext context, Widget widget, {RouteTransitionsBuilder? transition}) {
    Navigator.push(
      context,
      _createPageRoute(widget, transition: transition),
    );
  }

  static void pushAndRemove(BuildContext context, Widget widget, {RouteTransitionsBuilder? transition}) {
    Navigator.pushAndRemoveUntil(
      context,
      _createPageRoute(widget, transition: transition),
          (Route<dynamic> route) => false,
    );
  }

  static PageRouteBuilder _createPageRoute(Widget widget, {RouteTransitionsBuilder? transition}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: transition ?? _quickSwipeTransition,
    );
  }

  static Widget _quickSwipeTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const curve = Curves.easeInOut;

    // Slide transition for the current page (fade out and slide off to the left)
    final slideTweenCurrent = Tween(begin: const Offset(0.0, 0.0), end: const Offset(-1.0, 0.0))
        .chain(CurveTween(curve: curve));
    final slideAnimationCurrent = secondaryAnimation.drive(slideTweenCurrent);

    // Slide transition for the new page (from right to left)
    final slideTweenNext = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: curve));
    final slideAnimationNext = animation.drive(slideTweenNext);

    // Stronger fade transition for the new page (make the old page fade out)
    final fadeAnimationCurrent = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: secondaryAnimation, curve: curve),
    );

    final fadeAnimationNext = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animation, curve: curve),
    );

    return Stack(
      children: [
        // The current page fades out and slides off
        FadeTransition(
          opacity: fadeAnimationCurrent,
          child: SlideTransition(
            position: slideAnimationCurrent,
            child: const SizedBox.expand(),  // Empty space for current page to slide off
          ),
        ),
        // The new page fades in and slides in
        FadeTransition(
          opacity: fadeAnimationNext,
          child: SlideTransition(
            position: slideAnimationNext,
            child: child,
          ),
        ),
      ],
    );
  }





}
