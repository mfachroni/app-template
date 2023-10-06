import 'package:app_template/app_template_controller_widget.dart';
import 'package:app_template/controller/app_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppTemplate extends StatefulWidget {
  // final Widget child;
  final Widget Function(BuildContext context) builder;
  final String Function() getCurrentLocation;
  final AppController appController;
  const AppTemplate({
    super.key,
    required this.appController,
    required this.getCurrentLocation,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() {
    return _StatePage();
  }
}

class _StatePage extends State<AppTemplate> {
  @override
  Widget build(BuildContext context) {
    return AppTemplateControllerWidget(
      appController: widget.appController,
      getCurrentLocation: widget.getCurrentLocation,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => widget.appController,
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            return widget.builder(context);
          },
        ),
      ),
    );
  }
}
