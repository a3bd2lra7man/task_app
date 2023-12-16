import 'package:flutter/material.dart';
import 'package:task_app/main.dart';

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
  none,
}

class ScreenNavigator {
  static Future<dynamic> navigateTo(
    Widget screen, {
    SlideDirection? slideDirection,
    int duration = 200,
  }) {
    slideDirection ??= SlideDirection.fromRight;
    return Navigator.push(
      navigatorKey.currentContext!,
      _getPageRouteBuilder(screen, slideDirection, duration: duration),
    );
  }

  static pop([result]) {
    return Navigator.pop(navigatorKey.currentContext!, result);
  }

  static PageRouteBuilder _getPageRouteBuilder(Widget screen, SlideDirection slideDirection, {int duration = 200}) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        var begin = _getBeginOffset(slideDirection);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: duration),
    );
  }

  static Offset _getBeginOffset(SlideDirection slideDirection) {
    if (slideDirection == SlideDirection.fromLeft) {
      return const Offset(-1.0, 0.0);
    } else if (slideDirection == SlideDirection.fromRight) {
      return const Offset(1.0, 0.0);
    } else if (slideDirection == SlideDirection.fromTop) {
      return const Offset(0.0, -1.0);
    } else if (slideDirection == SlideDirection.fromBottom) {
      return const Offset(0.0, 1.0);
    } else {
      return Offset.zero;
    }
  }
}
