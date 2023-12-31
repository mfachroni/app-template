import 'package:app_template/app_layout.dart';
import 'package:app_template/page_shimmer.dart';
import 'package:app_template/utils/app_page_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final Widget body;
  final bool scrollable;
  final Future<Response> Function(BuildContext context)? initialLoad;

  final Function(AppPageData initalData)? onInitSuccess;
  const AppPage({
    super.key,
    required this.body,
    this.onInitSuccess,
    this.initialLoad,
    this.scrollable = false,
  });

  @override
  State<StatefulWidget> createState() {
    return AppPageState();
  }
}

class AppPageState extends State<AppPage> {
  bool _isLoading = true;
  DioException? dioException;
  AppPageData _appPageData = AppPageData();

  @override
  void initState() {
    if (widget.initialLoad != null) {
      Future.delayed(Duration.zero, () async {
        load();
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    super.initState();
  }

  void load() {
    setState(() {
      _isLoading = true;
    });
    _appPageData
        .processResponse(context, initialLoad: widget.initialLoad!)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      widget.onInitSuccess!(value);
    }).onError((error, stackTrace) {
      setState(() {
        dioException = error as DioException;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _isLoading ? const PageShimmer() : _buildBody(),
      scrollable: widget.scrollable,
    );
  }

  Widget _buildBody() {
    if (dioException != null) {
      if (dioException!.type == DioExceptionType.badResponse) {
        if (dioException!.response!.statusCode == 403) {
          return Center(
              child: Text(
            dioException!.response!.statusMessage!,
          ));
        }

        if (dioException!.response!.statusCode == 404) {
          return Center(
            child: Text(dioException!.response!.statusMessage!),
          );
        }
      }

      return Text('Something Error');
    } else {
      return widget.body;
    }
  }
}
