import 'package:app_template/app_layout.dart';
import 'package:app_template/page_shimmer.dart';
import 'package:app_template/utils/app_page_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final Widget body;
  // final String? initUrl;
  final AppPageData? initialPageData;
  final Function(AppPageData initalData)? onInitSuccess;
  const AppPage(
      {super.key,
      required this.body,
      this.onInitSuccess,
      this.initialPageData,});

  @override
  State<StatefulWidget> createState() {
    return AppPageState();
  }
}

class AppPageState extends State<AppPage> {
  bool _isLoading = false;
  DioException? dioException;

  @override
  void initState() {
    if (widget.initialPageData != null) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          _isLoading = true;
        });
        widget.initialPageData!
            .processResponse(
          context,
        )
            .then((value) {
          setState(() {
            _isLoading = false;
          });
          widget.onInitSuccess!(value);
        }).onError((error, stackTrace) {
          setState(() {
            _isLoading = false;
          });
        });
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
