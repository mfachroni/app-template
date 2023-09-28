import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppFormSelect extends StatelessWidget {
  final bool multiple;
  final bool showSearchBox;
  final Future<Response> Function(String search)? serverItems;
  final SelectData? selectedData;
  final Function(SelectData? selectedData) onChanged;
  const AppFormSelect({
    super.key,
    this.multiple = false,
    this.showSearchBox = true,
    required this.serverItems,
    this.selectedData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return multiple ? _buildMultiple() : _buildSingle(context);
  }

  Widget _buildSingle(BuildContext context) {
    return DropdownSearch<SelectData>(
      asyncItems: serverItems == null
          ? null
          : (text) async {
              Response response = await serverItems!(text);

              return (response.data['results'] as List)
                  .map((e) => SelectData(id: e['id'], text: e['text']))
                  .toList();
            },
      selectedItem: selectedData,
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        isFilterOnline: true,
        // showSelectedItems: true,
      ),
      itemAsString: (item) {
        return item.text;
      },
      onChanged: (value) {
        onChanged(value);
      },
    );
  }

  Widget _buildMultiple() {
    return DropdownSearch<SelectData>.multiSelection();
  }
}

class SelectData {
  final String id;
  final String text;

  const SelectData({required this.id, required this.text});
}
