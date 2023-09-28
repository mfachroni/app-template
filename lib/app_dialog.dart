import 'package:flutter/material.dart';

class AppDialog extends StatefulWidget {
  final Widget child;
  final String title;
  final AppDialogType type;
  final List<Widget> footer;
  const AppDialog({
    super.key,
    required this.title,
    this.type = AppDialogType.medium,
    this.footer = const [],
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _StatePage();
  }
}

class _StatePage extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: widget.child,
            ),
            if (widget.footer.isNotEmpty)
              const Divider(
                height: 24,
              ),
            if (widget.footer.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.footer,
                ),
              ),
          ],
        ),
      ),
    );
  }

  double get width {
    if (widget.type == AppDialogType.small) {
      return 400;
    }

    if (widget.type == AppDialogType.medium) {
      return 600;
    }

    if (widget.type == AppDialogType.large) {
      return 920;
    }

    if (widget.type == AppDialogType.full) {
      return double.infinity;
    }

    return 600;
  }
}

enum AppDialogType {
  small,
  medium,
  large,
  full,
}
