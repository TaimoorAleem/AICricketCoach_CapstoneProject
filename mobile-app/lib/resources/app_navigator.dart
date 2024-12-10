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
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: transition ?? _quickSwipeTransition,
    );
  }

  static Widget _quickSwipeTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const curve = Curves.linear; // Linear for a quick swipe effect
    final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
