import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppDataTable extends StatefulWidget {
  final double? rowHeight;
  final List<Widget> actions;
  final bool enableSearch;
  final bool stripped;
  final bool enableSelection;
  final List<AppDataTableColumn> columns;
  final Future<Response> Function(Map<String, dynamic> queryParameter) loadData;
  final int? defaultColumnSort;
  final Function(AppDataTableSource dataSource)? onCreated;
  const AppDataTable({
    super.key,
    // required this.source,
    this.rowHeight,
    this.actions = const [],
    this.enableSearch = true,
    this.stripped = true,
    this.enableSelection = false,
    required this.loadData,
    required this.columns,
    this.onCreated,
    this.defaultColumnSort,
  });

  @override
  State<StatefulWidget> createState() {
    return AppDataTableState();
  }
}

class AppDataTableState extends State<AppDataTable> {
  int _rowsPerPage = 15;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  AppDataTableSource? _dataSource;
  final PaginatorController _controller = PaginatorController();
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  // ignore: unused_field, prefer_final_fields
  bool _dataSourceLoading = false;
  // ignore: prefer_final_fields
  int _initialRow = 0;

  @override
  void initState() {
    _dataSource = AppDataTableSource(
      context,
      loadData: widget.loadData,
      columns: widget.columns,
      sortColumn: widget.defaultColumnSort ?? 0,
      paginatorController: _controller,
    );
    _dataSource!.enableSelection = widget.enableSelection;

    if (widget.onCreated != null) {
      widget.onCreated!(_dataSource!);
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    _dataSource!.sort(columnIndex, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    if (_dataSource != null) {
      _dataSource!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            if (widget.enableSearch)
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      splashRadius: 16,
                      onPressed: () {
                        _searchController.text = '';
                        _dataSource!.setSearch(_searchController.text);
                      },
                      icon: const Icon(Icons.close),
                      focusColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade300,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  onChanged: (value) {
                    _debouncer.run(() => _dataSource!.setSearch(value));
                  },
                ),
              ),
            if (widget.enableSearch)
              const SizedBox(
                width: 12,
              ),
            ...widget.actions.map((e) => e).toList(),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: AsyncPaginatedDataTable2(
              horizontalMargin: 16,
              checkboxHorizontalMargin: 12,
              columnSpacing: 16,
              wrapInCard: false,
              rowsPerPage: _rowsPerPage,
              autoRowsToHeight: false,
              availableRowsPerPage: const [10, 15, 20, 50, 100],
              pageSyncApproach: PageSyncApproach.doNothing,
              minWidth: 800,

              // renderEmptyRowsInTheEnd: true,
              fit: FlexFit.loose,
              border: TableBorder(
                top: const BorderSide(color: Colors.grey, width: 1),
                bottom: const BorderSide(color: Colors.grey, width: 1),
                horizontalInside:
                    BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              headingRowHeight: 48,
              dataRowHeight: widget.rowHeight ?? 44,
              onRowsPerPageChanged: (value) {
                _rowsPerPage = value!;
              },
              initialFirstRowIndex: _initialRow,
              onPageChanged: (rowIndex) {},
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              sortArrowIcon: Icons.keyboard_arrow_up,
              sortArrowAnimationDuration: const Duration(milliseconds: 0),
              // onSelectAll: (value) {},
              controller: _controller,
              hidePaginator: false,
              renderEmptyRowsInTheEnd: false,
              columns: _dataSource!.columns
                  .map(
                    (e) => DataColumn2(
                      label: Align(
                        alignment: e.alignment ?? Alignment.centerLeft,
                        child: Text(
                          e.label,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      fixedWidth: e.fixedWidth,
                      onSort: e.orderable
                          ? (columnIndex, ascending) {
                              sort(columnIndex, ascending);
                            }
                          : null,
                    ),
                  )
                  .toList(),
              empty: Center(
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text('No data'))),
              loading: _Loading(),
              errorBuilder: (e) => _ErrorAndRetry(
                  e.toString(), () => _dataSource!.refreshDatasource()),
              source: _dataSource!),
        ),
      ],
    );
  }
}

class AppDataTableSource extends AsyncDataTableSource {
  final BuildContext context;
  String? search;
  final bool isStrippedTable;
  bool? enableSelection;
  Future<Response> Function(Map<String, dynamic> queryParameter) loadData;
  final Function()? onTap;
  List<AppDataTableColumn> columns;
  List<AppDataTableFilter> filters = [];
  final PaginatorController paginatorController;

  int? sortColumn;
  bool sortAscending;

  AppDataTableSource(
    this.context, {
    required this.loadData,
    required this.columns,
    required this.paginatorController,
    this.isStrippedTable = true,
    this.onTap,
    this.sortAscending = true,
    this.sortColumn = 0,
    // this.enableSelection = false,
  });

  int? _errorCounter;

  void sort(int columnIndex, bool ascending) {
    sortColumn = columnIndex;
    sortAscending = ascending;
    refreshDatasource();
  }

  bool resetStartInSearch = false;

  void setSearch(String? value) {
    search = value;
    paginatorController.goToFirstPage();
    // refreshDatasource();
    // resetStartInSearch = false;
  }

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    // if (resetStartInSearch) {
    //   start = 0;
    // }

    // List returned will be empty is there're fewer items than startingAt
    var queryParameter = <String, dynamic>{
      'start': start.toString(),
      'length': end.toString(),
      'search[value]': search ?? '',
      for (var i = 0; i < columns.length; i++)
        'columns[$i][data]': columns[i].data,
      for (var i = 0; i < columns.length; i++)
        'columns[$i][name]': columns[i].name,
      for (var i = 0; i < columns.length; i++)
        'columns[$i][searchable]': columns[i].searchable,
      'order[0][column]': (sortColumn).toString(),
      'order[0][dir]': sortAscending ? 'asc' : 'dsc',
      'filters': filters
          .map((e) => {
                'field': e.field,
                'value': e.value,
              })
          .toList()
    };
    Response response = await loadData(queryParameter);
    AsyncRowsResponse newRows =
        AsyncRowsResponse(response.data['recordsFiltered'], []);
    // int indexRow = 0;
    (response.data['data'] as List).asMap().entries.forEach((element) {
      // for (Map element in response.data['data']) {
      newRows.rows.add(
        DataRow2(
            key: ValueKey<String>(element.value['id']),
            // ignore: use_build_context_synchronously
            // color: Theme.of(context).brightness == Brightness.dark
            //     ? null
            //     : isStrippedTable
            //         ? MaterialStateProperty.resolveWith<Color>(
            //             (Set<MaterialState> states) {
            //             // if (element.containsKey('DT_RowIndex')) {
            //             //   indexRow = element['DT_RowIndex'];
            //             // } else {
            //             //   indexRow = indexRow + 1;
            //             // }
            //             return element.key.isEven
            //                 ? Theme.of(context)
            //                     .colorScheme
            //                     .surface // Color.fromRGBO(248, 250, 251, 1)
            //                 : Theme.of(context).colorScheme.surfaceVariant;
            //           })
            //         : null,
            cells: columns.map(
              (e) {
                return e.render != null
                    ? DataCell(
                        // Material(
                        //   color: element.key.isEven
                        //       ? Theme.of(context)
                        //           .colorScheme
                        //           .surface // Color.fromRGBO(248, 250, 251, 1)
                        //       : Theme.of(context).colorScheme.surfaceVariant,
                        // child:
                        e.render!(element.value[e.data], element.value),
                        // ),
                      )
                    : DataCell(
                        // Material(
                        // color: element.key.isEven
                        //     ? Theme.of(context)
                        //         .colorScheme
                        //         .surface // Color.fromRGBO(248, 250, 251, 1)
                        //     : Theme.of(context).colorScheme.surfaceVariant,
                        // child:
                        Align(
                          alignment: e.alignment ?? Alignment.centerLeft,
                          child: Text(
                            element.value[e.data]?.toString() ??
                                e.defaultValue ??
                                '-',
                            // ),
                          ),
                        ),
                      );
              },
            ).toList(),
            onSelectChanged: enableSelection!
                ? (value) {
                    if (value != null) {
                      setRowSelection(
                          ValueKey<String>(element.value['id']), value);
                    }
                  }
                : null,
            onTap: onTap),
      );
    });
    return newRows;
  }

  void setFilter(AppDataTableFilter appDataTableFilter) {
    var index = filters
        .indexWhere((element) => element.field == appDataTableFilter.field);

    if (index != -1) {
      filters[index].value = appDataTableFilter.value;
    } else {
      filters.add(appDataTableFilter);
    }

    paginatorController.goToFirstPage();
  }

  void removeFilter(String field) {
    var index = filters.indexWhere((element) => element.field == field);

    if (index != -1) {
      filters.removeAt(index);
    }

    notifyListeners();
    refreshDatasource();
  }
}

class AppDataTableColumn {
  String label;
  String data;
  String name;
  bool searchable;
  bool orderable;
  double? fixedWidth;
  Alignment? alignment;
  String? defaultValue;
  final Widget Function(dynamic data, dynamic full)? render;

  AppDataTableColumn(
      {required this.label,
      required this.data,
      required this.name,
      this.searchable = true,
      this.orderable = false,
      this.fixedWidth,
      this.alignment,
      this.render,
      this.defaultValue});
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oops! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: retry,
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}

class _Loading extends StatefulWidget {
  @override
  __LoadingState createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white.withAlpha(128),
        // at first show shade, if loading takes longer than 0,5s show spinner
        child: FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 500), () => true),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SizedBox()
                  : Center(
                      child: Container(
                      color: Colors.yellow,
                      padding: const EdgeInsets.all(7),
                      width: 150,
                      height: 50,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                            Text('Loading..')
                          ]),
                    ));
            }));
  }
}

class AppDataTableFilter {
  String field;
  dynamic value;

  AppDataTableFilter({
    required this.field,
    required this.value,
  });
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
