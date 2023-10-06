import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AppPageData {
  List<ActionClass> actions = [];

  late Response response;

  AppPageData({
    this.actions = const [],
  });

  bool can(String action) {
    int index = actions.indexWhere((element) => element.action == action);
    if (index != -1) {
      return actions[index].allow;
    }
    return false;
  }

  Future<AppPageData> processResponse(BuildContext context,
      {required Future<Response> Function(BuildContext context)
          initialLoad}) async {
    response = await initialLoad(context);
    actions = response.data['actions'] != null
        ? (response.data['actions'] as Map<dynamic, dynamic>)
            .entries
            .map((e) => ActionClass(action: e.key, allow: e.value))
            .toList()
        : [];
    return this;
  }
}

class ActionClass {
  String action;
  bool allow;

  ActionClass({required this.action, required this.allow});
}
