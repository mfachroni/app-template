import 'package:flutter/material.dart';

class AppFormLabel extends StatelessWidget {
  final String label;
  final Widget form;
  final bool showRequireIndicator;
  final AppFormDirection direction;
  final String? description;
  final double? widthLabel;
  const AppFormLabel({
    super.key,
    required this.label,
    required this.form,
    this.showRequireIndicator = false,
    this.direction = AppFormDirection.vertical,
    this.description,
    this.widthLabel,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      widthLabel != null
          ? SizedBox(
              width: widthLabel,
              child: _buildLabel(context),
            )
          : _buildLabel(context),
      const SizedBox(
        height: 8,
      ),
      direction == AppFormDirection.vertical
          ? _buildForm()
          : Expanded(child: _buildForm())
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8)
          .copyWith(bottom: 8),
      child: direction == AppFormDirection.vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: items)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: items,
            ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (showRequireIndicator)
          Text(
            '*',
            style: TextStyle(
              color: Colors.red.shade800,
            ),
          ),
        if (direction == AppFormDirection.horizontal)
          const SizedBox(
            width: 12,
          ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        form,
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        if (description != null)
          Text(
            description!,
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}

enum AppFormDirection {
  vertical,
  horizontal,
}
