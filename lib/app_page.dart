import 'package:app_template/app_layout.dart';
import 'package:app_template/page_shimmer.dart';
import 'package:app_template/utils/app_page_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final Widget body;
  // final String? initUrl;
  final Future<Response> Function(BuildContext context)? loadData;
  final Function(AppPageData initalData)? onInitSuccess;
  const AppPage(
      {super.key, required this.body, this.onInitSuccess, this.loadData});

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
    if (widget.loadData != null) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          _isLoading = true;
        });
        _appPageData
            .processResponse(
          context,
          loadData: widget.loadData!,
        )
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
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: _isLoading ? const PageShimmer() : _buildBody());
  }

  Widget _buildBody() {
    if (dioException != null) {
      if (dioException!.type == DioExceptionType.badResponse) {
        if (dioException!.response!.statusCode == 403) {
          return Text(dioException!.response!.statusMessage!);
        }
      }

      return Text('Something Error');
    }
    return widget.body;
  }
}
