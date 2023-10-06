import 'package:app_template/app_container.dart';
import 'package:app_template/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final bool withHeader;
  final bool withDivider;
  final MainAxisAlignment actionsAlignment;
  final List<Widget> actions;
  final EdgeInsets bodyPadding;
  final bool withBorder;
  final Widget? leading;
  const AppCard({
    super.key,
    this.child,
    this.title,
    this.withHeader = true,
    this.withDivider = true,
    this.actions = const [],
    this.actionsAlignment = MainAxisAlignment.end,
    this.bodyPadding = EdgeInsets.zero,
    this.withBorder = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: withBorder
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.grey.shade200,
              ),
            )
          : null,
      elevation: Provider.of<AppController>(context, listen: false).elevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withHeader)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (leading != null) leading!,
                    if (leading != null)
                      const SizedBox(
                        width: 8,
                      ),
                    if (title != null)
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: actionsAlignment,
                        children: actions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (withHeader && withDivider) const Divider(height: 0),
          if (withHeader && withDivider)
            const SizedBox(
              height: 16,
            ),
          if (child != null)
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: bodyPadding,
                child: child!,
              ),
            ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
