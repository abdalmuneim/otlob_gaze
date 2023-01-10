import 'package:flutter/material.dart';
import 'package:otlob_gas/common/routes/routes.dart';

class NavigationService {
  static BuildContext get context =>
      Routes.router.routerDelegate.navigatorKey.currentContext!;
}
