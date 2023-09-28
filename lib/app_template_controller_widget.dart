import 'package:app_template/app_controller.dart';
import 'package:flutter/widgets.dart';

class AppTemplateControllerWidget extends InheritedWidget {
  final AppController appController;
  const AppTemplateControllerWidget({
    super.key,
    required super.child,
    required this.appController,
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
