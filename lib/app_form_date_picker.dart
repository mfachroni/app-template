import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFormDatePicker extends StatefulWidget {
  final String? hintText;
  final AppDatePickerController controller;
  final bool readOnly;

  final Function(DateTime)? onSelected;

  const AppFormDatePicker({
    super.key,
    this.hintText,
    this.onSelected,
    required this.controller,
    this.readOnly = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _StatePage();
  }
}

class _StatePage extends State<AppFormDatePicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
            text: widget.controller.value != null
                ? DateFormat('dd/MM/y').format(widget.controller.value!)
                : ''),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Date Picker',
          suffixIcon: Icon(
            Icons.calendar_month,
            color: Colors.grey.shade700,
          ),
        ),
        onTap: widget.readOnly
            ? null
            : () {
                showDatePicker(
                  context: context,
                  initialDate: widget.controller.value ?? DateTime.now(),
                  firstDate: widget.controller.value != null
                      ? widget.controller.value!
                          .subtract(const Duration(days: 365))
                      : DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: widget.controller.value != null
                      ? widget.controller.value!.add(const Duration(days: 365))
                      : DateTime.now().add(const Duration(days: 365)),
                ).then((value) {
                  if (value != null) {
                    widget.controller.value = value;
                    if (widget.onSelected != null) {
                      widget.onSelected!(value);
                    }
                  }
                  setState(() {});
                });
              },
      ),
    );
  }
}

class AppDatePickerController extends ChangeNotifier {
  DateTime? value;

  AppDatePickerController({
    this.value,
  });
}
