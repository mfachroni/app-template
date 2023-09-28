import 'package:app_template/app_controller.dart';
import 'package:flutter/widgets.dart';

class AppTemplateControllerWidget extends InheritedWidget {
  final AppController appController;
  final String Function() getCurrentLocation;
  const AppTemplateControllerWidget({
    super.key,
    required super.child,
    required this.appController,
    required this.getCurrentLocation,
  });

  static AppTemplateControllerWidget? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<AppTemplateControllerWidget>();

  static loadSideMenu(BuildContext context) {
    AppTemplateControllerWidget.of(context)!
        .appController
        .loadSideMenu(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
